//
//  ControlView.swift
//  FocusShift
//
//  Main control screen with shift/unshift button
//

import SwiftUI

struct ControlView: View {
    @StateObject private var deviceManager = DeviceManager()
    @State private var selectedDuration: TimeInterval? = nil
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isSupervised = false
    @State private var checkingSupervision = true

    // Available focus session durations (in seconds)
    private let durations: [TimeInterval?] = [nil, 30 * 60, 60 * 60, 90 * 60]

    var body: some View {
        // Show setup wizard if device is connected but not supervised
        if deviceManager.connectedDevice != nil && !isSupervised && !checkingSupervision {
            SupervisionSetupView(deviceManager: deviceManager)
        } else {
            mainControlView
        }
    }

    private var mainControlView: some View {
        VStack(spacing: 30) {
            // Connection Status
            StatusIndicatorView(deviceManager: deviceManager)
                .padding(.top, 20)

            Spacer()

            // Main Control Card
            VStack(spacing: 25) {
                // Status Text
                Text(deviceManager.isShifted ? "Phone is Shifted" : "Phone is Unshifted")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(deviceManager.isShifted ? "Focus mode active" : "All apps available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Main Shift/Unshift Button
                Button(action: handleMainButtonTap) {
                    HStack {
                        Image(systemName: deviceManager.isShifted ? "sparkles" : "moon.fill")
                            .font(.title2)

                        Text(deviceManager.isShifted ? "Unshift iPhone" : "Shift iPhone")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 240, height: 80)
                    .background(buttonColor)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 8)
                }
                .disabled(deviceManager.isProcessing || !canUnshift)

                // Focus session countdown
                if let session = PreferencesManager.shared.loadFocusSession(), session.isActive {
                    Text("Session ends in \(session.remainingTimeString)")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }

                // Focus Session Duration Picker (only show when unshifted)
                if !deviceManager.isShifted {
                    FocusSessionPickerView(selectedDuration: $selectedDuration)
                }
            }
            .padding(30)
            .background(Color(.windowBackgroundColor))
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal, 40)

            Spacer()

            // Next scheduled action (if any)
            if let nextSchedule = getNextSchedule() {
                Text("Next scheduled: \(nextSchedule.action.displayName) at \(nextSchedule.timeString)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .task {
            // Detect device on appear
            do {
                _ = try await deviceManager.detectDevice()

                // Check if device is supervised
                if deviceManager.connectedDevice != nil {
                    isSupervised = (try? await deviceManager.isDeviceSupervised()) ?? false
                }
                checkingSupervision = false
            } catch {
                print("Failed to detect device: \(error)")
                checkingSupervision = false
            }
        }
    }

    // MARK: - Computed Properties

    private var buttonColor: Color {
        if deviceManager.isProcessing {
            return Color.gray
        }
        return deviceManager.isShifted ? Color.purple : Color.blue
    }

    private var canUnshift: Bool {
        if !deviceManager.isShifted {
            return true
        }

        // Check if there's an active focus session
        if let session = PreferencesManager.shared.loadFocusSession(), session.isActive {
            return false
        }

        return true
    }

    // MARK: - Actions

    private func handleMainButtonTap() {
        Task {
            do {
                if deviceManager.isShifted {
                    try await deviceManager.unshiftDevice()
                } else {
                    try await deviceManager.shiftDevice(duration: selectedDuration)
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    private func getNextSchedule() -> Schedule? {
        let schedules = ScheduleManager.shared.schedules.filter { $0.isEnabled }
        // In a real implementation, you'd find the actual next schedule
        return schedules.first
    }
}

// MARK: - Focus Session Picker

struct FocusSessionPickerView: View {
    @Binding var selectedDuration: TimeInterval?

    private let options: [(String, TimeInterval?)] = [
        ("No Timer", nil),
        ("30 min", 30 * 60),
        ("60 min", 60 * 60),
        ("90 min", 90 * 60),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Focus Session Duration")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 10) {
                ForEach(options, id: \.0) { option in
                    Button(action: {
                        selectedDuration = option.1
                    }) {
                        Text(option.0)
                            .font(.caption)
                            .fontWeight(selectedDuration == option.1 ? .semibold : .regular)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedDuration == option.1 ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
                            .foregroundColor(selectedDuration == option.1 ? .purple : .primary)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Status Indicator

struct StatusIndicatorView: View {
    @ObservedObject var deviceManager: DeviceManager

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(statusColor)
                .frame(width: 10, height: 10)

            Text(statusText)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var statusColor: Color {
        if deviceManager.isProcessing {
            return .orange
        }
        return deviceManager.connectedDevice != nil ? .green : .red
    }

    private var statusText: String {
        if deviceManager.isProcessing {
            return "Processing..."
        }
        if let device = deviceManager.connectedDevice {
            return "Connected - \(device.name)"
        }
        return "iPhone not connected"
    }
}

#Preview {
    ControlView()
        .frame(width: 600, height: 500)
}
