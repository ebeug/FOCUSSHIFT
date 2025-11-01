//
//  DeviceManager.swift
//  FocusShift
//
//  Manages communication with the iPhone via cfgutil
//

import Foundation
import Combine

class DeviceManager: ObservableObject {
    // Published properties that views can observe
    @Published var connectedDevice: iPhoneDevice?
    @Published var isShifted: Bool = false
    @Published var isProcessing: Bool = false
    @Published var lastError: String?

    // Path to cfgutil command-line tool
    private let cfgutilPath = "/Applications/Apple Configurator.app/Contents/MacOS/cfgutil"

    // Profile identifier (must match in all profile operations)
    private let profileIdentifier = "com.focusshift.restrictions"

    // MARK: - Device Detection

    /// Detect if an iPhone is connected via USB or WiFi
    func detectDevice() async throws -> iPhoneDevice? {
        let output = try await runCommand([cfgutilPath, "list"])

        // Parse the output to extract device info
        // Format is typically: "UDID    Name"
        guard !output.isEmpty else {
            return nil
        }

        let lines = output.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard let firstLine = lines.first else {
            return nil
        }

        // Parse UDID and name from the line
        let components = firstLine.split(separator: "\t").map(String.init)
        guard components.count >= 2 else {
            return nil
        }

        let device = iPhoneDevice(
            id: components[0],
            name: components[1],
            isConnected: true,
            isShifted: isShifted,
            lastSeenAt: Date()
        )

        await MainActor.run {
            self.connectedDevice = device
        }

        return device
    }

    // MARK: - Shift Operations

    /// Apply restrictions to the iPhone (enter focus mode)
    func shiftDevice(duration: TimeInterval? = nil) async throws {
        await MainActor.run {
            isProcessing = true
            lastError = nil
        }

        defer {
            Task { @MainActor in
                isProcessing = false
            }
        }

        // Get the list of blocked apps and domains from preferences
        let blockedApps = PreferencesManager.shared.getBlockedApps()
        let blockedDomains = PreferencesManager.shared.getBlockedDomains()

        // Generate the configuration profile
        let profileXML = ProfileGenerator.createRestrictionsProfile(
            blockedApps: blockedApps,
            blockedDomains: blockedDomains
        )

        // Write profile to temporary file
        let profilePath = "/tmp/focusshift-restrict.mobileconfig"
        try profileXML.write(toFile: profilePath, atomically: true, encoding: .utf8)

        // Install the profile on the iPhone
        try await runCommand([cfgutilPath, "install-profile", profilePath])

        await MainActor.run {
            isShifted = true
        }

        // If duration is specified, create a focus session
        if let duration = duration {
            let session = FocusSession(
                startedAt: Date(),
                endsAt: Date().addingTimeInterval(duration)
            )
            PreferencesManager.shared.saveFocusSession(session)
        }

        print("✅ iPhone shifted successfully")
    }

    /// Remove restrictions from the iPhone (exit focus mode)
    func unshiftDevice() async throws {
        await MainActor.run {
            isProcessing = true
            lastError = nil
        }

        defer {
            Task { @MainActor in
                isProcessing = false
            }
        }

        // Check if there's an active focus session
        if let session = PreferencesManager.shared.loadFocusSession(), session.isActive {
            throw NSError(
                domain: "FocusShift",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Cannot unshift during active focus session. \(session.remainingTimeString) remaining."]
            )
        }

        // Remove the profile from the iPhone
        try await runCommand([cfgutilPath, "remove-profile", profileIdentifier])

        await MainActor.run {
            isShifted = false
        }

        // Clear focus session if any
        PreferencesManager.shared.clearFocusSession()

        print("✅ iPhone unshifted successfully")
    }

    // MARK: - App Management

    /// Fetch list of installed apps from the iPhone
    func fetchInstalledApps() async throws -> [App] {
        let output = try await runCommand([cfgutilPath, "list-apps"])

        // Parse the output to extract app bundle IDs
        let lines = output.components(separatedBy: .newlines)
            .filter { !$0.isEmpty && !$0.hasPrefix("ECID") }

        var apps: [App] = []

        for line in lines {
            // Expected format: "com.example.app    AppName"
            let components = line.split(separator: "\t").map(String.init)
            guard components.count >= 1 else { continue }

            let bundleID = components[0]
            let appName = components.count >= 2 ? components[1] : bundleID

            // Determine category based on bundle ID
            let category = AppManager.shared.categorizeApp(bundleID: bundleID)

            let app = App(
                id: bundleID,
                name: appName,
                iconData: nil,
                category: category,
                isBlockedWhenShifted: category.isBlockedByDefault
            )

            apps.append(app)
        }

        return apps
    }

    // MARK: - Emergency Operations

    /// Completely remove supervision from the iPhone (EMERGENCY USE ONLY)
    func removeSupervision() async throws {
        await MainActor.run {
            isProcessing = true
            lastError = nil
        }

        defer {
            Task { @MainActor in
                isProcessing = false
            }
        }

        try await runCommand([cfgutilPath, "remove-supervision"])

        await MainActor.run {
            connectedDevice = nil
            isShifted = false
        }

        // Clear all saved state
        PreferencesManager.shared.clearAllData()

        print("⚠️ Supervision removed. FocusShift can no longer control this iPhone.")
    }

    // MARK: - Helper Methods

    /// Run a shell command and return the output
    private func runCommand(_ arguments: [String]) async throws -> String {
        let process = Process()
        let pipe = Pipe()

        process.executableURL = URL(fileURLWithPath: arguments[0])
        process.arguments = Array(arguments.dropFirst())
        process.standardOutput = pipe
        process.standardError = pipe

        return try await withCheckedThrowingContinuation { continuation in
            do {
                try process.run()

                process.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? ""

                if process.terminationStatus == 0 {
                    continuation.resume(returning: output)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "FocusShift",
                        code: Int(process.terminationStatus),
                        userInfo: [NSLocalizedDescriptionKey: "Command failed: \(output)"]
                    ))
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
