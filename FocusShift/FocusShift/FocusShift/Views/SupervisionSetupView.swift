//
//  SupervisionSetupView.swift
//  FocusShift
//
//  One-time setup wizard for supervising the iPhone
//

import SwiftUI

struct SupervisionSetupView: View {
    @ObservedObject var deviceManager: DeviceManager
    @State private var currentStep: SetupStep = .welcome
    @State private var progressMessage = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isSettingUp = false

    enum SetupStep {
        case welcome
        case prerequisites
        case inProgress
        case complete
    }

    var body: some View {
        VStack(spacing: 30) {
            // Header
            Image(systemName: "iphone.and.arrow.forward")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("iPhone Supervision Setup")
                .font(.title)
                .fontWeight(.bold)

            // Content based on current step
            switch currentStep {
            case .welcome:
                welcomeView
            case .prerequisites:
                prerequisitesView
            case .inProgress:
                progressView
            case .complete:
                completeView
            }

            Spacer()
        }
        .padding(40)
        .alert("Setup Error", isPresented: $showError) {
            Button("OK", role: .cancel) {
                currentStep = .prerequisites
            }
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Step Views

    private var welcomeView: some View {
        VStack(spacing: 20) {
            Text("Welcome to FocusShift!")
                .font(.title2)
                .fontWeight(.semibold)

            Text("To hide distracting apps from your iPhone, we need to set up supervision. This is a one-time process that takes about 10 minutes.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            VStack(alignment: .leading, spacing: 12) {
                SetupFeatureRow(icon: "checkmark.shield", text: "Apps truly disappear from home screen")
                SetupFeatureRow(icon: "checkmark.shield", text: "Block websites in Safari")
                SetupFeatureRow(icon: "checkmark.shield", text: "Can't be bypassed like Screen Time")
                SetupFeatureRow(icon: "checkmark.shield", text: "All your data is preserved")
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)

            Button(action: {
                currentStep = .prerequisites
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }

    private var prerequisitesView: some View {
        VStack(spacing: 20) {
            Text("Before We Start")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Please complete these 3 quick steps:")
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 16) {
                PrerequisiteRow(
                    number: 1,
                    title: "Turn off Find My iPhone",
                    description: "Settings → [Your Name] → Find My → Find My iPhone → OFF"
                )

                PrerequisiteRow(
                    number: 2,
                    title: "Connect iPhone via USB",
                    description: "Use the cable that came with your iPhone"
                )

                PrerequisiteRow(
                    number: 3,
                    title: "Keep iPhone unlocked",
                    description: "Stay on the home screen during setup"
                )
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)

            Text("⏱️ This process takes 10-15 minutes and preserves all your data")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 16) {
                Button(action: {
                    currentStep = .welcome
                }) {
                    Text("Back")
                        .frame(width: 120, height: 50)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                }

                Button(action: startSupervision) {
                    Text("Start Setup")
                        .font(.headline)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(isSettingUp)
            }
        }
    }

    private var progressView: some View {
        VStack(spacing: 30) {
            ProgressView()
                .scaleEffect(1.5)

            Text(progressMessage)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("Please don't disconnect your iPhone or quit FocusShift")
                .font(.caption)
                .foregroundColor(.orange)
        }
    }

    private var completeView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("Setup Complete!")
                .font(.title)
                .fontWeight(.bold)

            Text("Your iPhone is now supervised and ready to use with FocusShift.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                Text("What's next:")
                    .font(.headline)

                Text("1. Re-enable Find My iPhone in Settings")
                Text("2. Click 'Shift iPhone' to hide distracting apps")
                Text("3. Customize which apps to block in Settings tab")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)

            Button(action: {
                // This will trigger a re-check of supervision status
                Task {
                    try? await deviceManager.detectDevice()
                }
            }) {
                Text("Start Using FocusShift")
                    .font(.headline)
                    .frame(width: 240, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }

    // MARK: - Actions

    private func startSupervision() {
        isSettingUp = true
        currentStep = .inProgress

        Task {
            do {
                try await deviceManager.setupSupervision { message in
                    await MainActor.run {
                        progressMessage = message
                    }
                }

                await MainActor.run {
                    currentStep = .complete
                    isSettingUp = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isSettingUp = false
                }
            }
        }
    }
}

// MARK: - Helper Views

struct SetupFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .font(.subheadline)
        }
    }
}

struct PrerequisiteRow: View {
    let number: Int
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.orange)
                .frame(width: 28, height: 28)
                .overlay(
                    Text("\(number)")
                        .font(.headline)
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SupervisionSetupView(deviceManager: DeviceManager())
        .frame(width: 600, height: 500)
}
