//
//  ContentView.swift
//  FocusShift
//
//  Main container view with tab navigation
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .control

    enum Tab {
        case control
        case settings
        case schedule
    }

    var body: some View {
        VStack(spacing: 0) {
            // Custom tab bar
            HStack(spacing: 0) {
                TabButton(
                    title: "Control",
                    icon: "moon.circle.fill",
                    isSelected: selectedTab == .control,
                    action: { selectedTab = .control }
                )

                TabButton(
                    title: "Settings",
                    icon: "gear.circle.fill",
                    isSelected: selectedTab == .settings,
                    action: { selectedTab = .settings }
                )

                TabButton(
                    title: "Schedule",
                    icon: "calendar.circle.fill",
                    isSelected: selectedTab == .schedule,
                    action: { selectedTab = .schedule }
                )
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(.windowBackgroundColor))

            Divider()

            // Content area
            Group {
                switch selectedTab {
                case .control:
                    ControlView()
                case .settings:
                    SettingsView()
                case .schedule:
                    ScheduleView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            // Emergency panel at bottom
            EmergencyPanelView()
        }
    }
}

// MARK: - Tab Button

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            .foregroundColor(isSelected ? .accentColor : .secondary)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Emergency Panel

struct EmergencyPanelView: View {
    @State private var isExpanded = false
    @State private var showingRemoveConfirmation = false
    @State private var confirmationText = ""
    @StateObject private var deviceManager = DeviceManager()

    var body: some View {
        VStack(spacing: 0) {
            // Collapsed header
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)

                    Text("Emergency Options")
                        .font(.caption)
                        .fontWeight(.semibold)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
            }
            .buttonStyle(.plain)

            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 15) {
                    Text("⚠️ Danger Zone")
                        .font(.headline)
                        .foregroundColor(.red)

                    Text("Removing supervision will completely disable FocusShift's control over your iPhone. You'll need to re-supervise to use the app again.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Button(action: {
                        showingRemoveConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Emergency: Remove All Supervision")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .background(Color(.windowBackgroundColor))
            }
        }
        .alert("Remove Supervision?", isPresented: $showingRemoveConfirmation) {
            TextField("Type REMOVE to confirm", text: $confirmationText)
            Button("Cancel", role: .cancel) {
                confirmationText = ""
            }
            Button("Remove", role: .destructive) {
                if confirmationText == "REMOVE" {
                    removeSupervision()
                }
                confirmationText = ""
            }
        } message: {
            Text("This will completely remove FocusShift's control over your iPhone. Type REMOVE to confirm.")
        }
    }

    private func removeSupervision() {
        Task {
            do {
                try await deviceManager.removeSupervision()
                print("✅ Supervision removed successfully")
            } catch {
                print("❌ Failed to remove supervision: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 800, height: 600)
}
