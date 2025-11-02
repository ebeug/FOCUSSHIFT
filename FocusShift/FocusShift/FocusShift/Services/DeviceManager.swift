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

    // MARK: - Supervision Status

    /// Check if the connected device is supervised
    func isDeviceSupervised() async throws -> Bool {
        let output = try await runCommand([cfgutilPath, "get", "IsSupervised"])
        return output.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "true"
    }

    // MARK: - Device Detection

    /// Detect if an iPhone is connected via USB or WiFi
    func detectDevice() async throws -> iPhoneDevice? {
        let output = try await runCommand([cfgutilPath, "list"])

        // Parse the output to extract device info
        // Format: "Type: iPhone16,2	ECID: 0x...	UDID: 00008130-... Location: 0x... Name: YourName"
        guard !output.isEmpty else {
            return nil
        }

        let lines = output.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard let firstLine = lines.first else {
            return nil
        }

        // Extract UDID and Name from the line
        var udid = ""
        var deviceName = "iPhone"

        let parts = firstLine.components(separatedBy: "\t")
        for part in parts {
            let trimmed = part.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("UDID:") {
                udid = trimmed.replacingOccurrences(of: "UDID: ", with: "").trimmingCharacters(in: .whitespaces)
            } else if trimmed.hasPrefix("Name:") {
                deviceName = trimmed.replacingOccurrences(of: "Name: ", with: "").trimmingCharacters(in: .whitespaces)
            }
        }

        guard !udid.isEmpty else {
            return nil
        }

        let device = iPhoneDevice(
            id: udid,
            name: deviceName,
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
        let profilePath = NSTemporaryDirectory() + "focusshift-restrict.mobileconfig"
        try profileXML.write(toFile: profilePath, atomically: true, encoding: .utf8)

        // Install the profile on the iPhone
        _ = try await runCommand([cfgutilPath, "install-profile", profilePath])

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
        _ = try await runCommand([cfgutilPath, "remove-profile", profileIdentifier])

        await MainActor.run {
            isShifted = false
        }

        // Clear focus session if any
        PreferencesManager.shared.clearFocusSession()

        print("✅ iPhone unshifted successfully")
    }

    // MARK: - App Management

    /// Fetch list of installed apps from the iPhone
    func fetchInstalledApps() async throws -> [BlockedApp] {
        let output = try await runCommand([cfgutilPath, "list-apps"])

        // Parse the output to extract app bundle IDs
        let lines = output.components(separatedBy: .newlines)
            .filter { !$0.isEmpty && !$0.hasPrefix("ECID") }

        var apps: [BlockedApp] = []

        for line in lines {
            // Expected format: "com.example.app    AppName"
            let components = line.split(separator: "\t").map(String.init)
            guard components.count >= 1 else { continue }

            let bundleID = components[0]
            let appName = components.count >= 2 ? components[1] : bundleID

            // Determine category based on bundle ID
            let category = AppManager.shared.categorizeApp(bundleID: bundleID)

            let app = BlockedApp(
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

    // MARK: - Supervision Setup

    /// Automated supervision workflow: backup → prepare → restore
    /// This is a one-time setup that takes 10-15 minutes
    func setupSupervision(progress: @escaping (String) -> Void) async throws {
        await MainActor.run {
            isProcessing = true
            lastError = nil
        }

        defer {
            Task { @MainActor in
                isProcessing = false
            }
        }

        // Check if already supervised
        if try await isDeviceSupervised() {
            throw NSError(
                domain: "FocusShift",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "Device is already supervised"]
            )
        }

        // Step 1: Backup the device
        await MainActor.run {
            progress("Creating backup of your iPhone... (this may take a few minutes)")
        }
        let backupPath = NSTemporaryDirectory() + "focusshift-backup-\(UUID().uuidString)"
        _ = try await runCommand([cfgutilPath, "backup", backupPath])
        print("✅ Backup created at: \(backupPath)")

        // Step 2: Prepare (supervise) the device
        await MainActor.run {
            progress("Supervising your iPhone... (device will restart)")
        }
        // Create supervision identity
        _ = try await runCommand([
            cfgutilPath,
            "prepare",
            "--supervised",
            "--skip-language",
            "--skip-region"
        ])
        print("✅ Device supervised")

        // Step 3: Restore the backup
        await MainActor.run {
            progress("Restoring your data... (almost done!)")
        }
        _ = try await runCommand([cfgutilPath, "restore", backupPath])
        print("✅ Backup restored")

        await MainActor.run {
            progress("Setup complete! 🎉")
        }

        // Clean up backup
        try? FileManager.default.removeItem(atPath: backupPath)
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

        _ = try await runCommand([cfgutilPath, "remove-supervision"])

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

                print("📝 Command output: \(output)")
                print("📝 Exit code: \(process.terminationStatus)")

                if process.terminationStatus == 0 {
                    continuation.resume(returning: output)
                } else {
                    let errorMsg = "Command failed with code \(process.terminationStatus): \(output)"
                    print("❌ \(errorMsg)")
                    continuation.resume(throwing: NSError(
                        domain: "FocusShift",
                        code: Int(process.terminationStatus),
                        userInfo: [NSLocalizedDescriptionKey: errorMsg]
                    ))
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
