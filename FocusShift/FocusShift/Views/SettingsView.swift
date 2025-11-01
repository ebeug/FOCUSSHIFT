//
//  SettingsView.swift
//  FocusShift
//
//  Settings screen for customizing blocked apps and domains
//

import SwiftUI

struct SettingsView: View {
    @State private var apps: [App] = []
    @State private var selectedCategory: App.AppCategory = .social
    @State private var blockedDomains: [String] = []
    @State private var newDomain = ""
    @State private var isRefreshing = false
    @State private var searchText = ""

    var body: some View {
        HSplitView {
            // Left sidebar - Categories
            VStack(alignment: .leading, spacing: 0) {
                Text("Categories")
                    .font(.headline)
                    .padding()

                List(App.AppCategory.allCases, id: \.self, selection: $selectedCategory) { category in
                    HStack {
                        Text(category.displayName)
                        Spacer()
                        Text("\(appsInCategory(category).count)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                .listStyle(.sidebar)
            }
            .frame(minWidth: 200, maxWidth: 250)

            // Right side - App list
            VStack(spacing: 0) {
                // Toolbar
                HStack {
                    TextField("Search apps...", text: $searchText)
                        .textFieldStyle(.roundedBorder)

                    Button("Refresh Apps") {
                        refreshApps()
                    }
                    .disabled(isRefreshing)

                    if isRefreshing {
                        ProgressView()
                            .scaleEffect(0.7)
                    }
                }
                .padding()

                Divider()

                // App list
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredApps) { app in
                            AppListItemView(app: binding(for: app))
                            Divider()
                        }
                    }
                }

                Divider()

                // Blocked Domains Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Blocked Websites")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(blockedDomains, id: \.self) { domain in
                                HStack(spacing: 4) {
                                    Text(domain)
                                        .font(.caption)
                                    Button(action: {
                                        removeDomain(domain)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }

                    HStack {
                        TextField("Add domain (e.g., example.com)", text: $newDomain)
                            .textFieldStyle(.roundedBorder)

                        Button("Add") {
                            addDomain()
                        }
                        .disabled(newDomain.isEmpty)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color(.windowBackgroundColor))
            }
        }
        .onAppear {
            loadData()
        }
    }

    // MARK: - Computed Properties

    private var filteredApps: [App] {
        let categoryApps = appsInCategory(selectedCategory)
        if searchText.isEmpty {
            return categoryApps
        }
        return categoryApps.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.id.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func appsInCategory(_ category: App.AppCategory) -> [App] {
        apps.filter { $0.category == category }
            .sorted { $0.name < $1.name }
    }

    private func binding(for app: App) -> Binding<App> {
        guard let index = apps.firstIndex(where: { $0.id == app.id }) else {
            fatalError("App not found")
        }
        return $apps[index]
    }

    // MARK: - Actions

    private func loadData() {
        // Load saved apps or fetch from device
        if let savedApps = PreferencesManager.shared.loadApps() {
            apps = savedApps
        } else {
            refreshApps()
        }

        blockedDomains = PreferencesManager.shared.getBlockedDomains()
    }

    private func refreshApps() {
        isRefreshing = true
        Task {
            do {
                let deviceManager = DeviceManager()
                let fetchedApps = try await deviceManager.fetchInstalledApps()
                await MainActor.run {
                    apps = fetchedApps
                    PreferencesManager.shared.saveApps(apps)
                    isRefreshing = false
                }
            } catch {
                print("Failed to fetch apps: \(error)")
                await MainActor.run {
                    isRefreshing = false
                }
            }
        }
    }

    private func addDomain() {
        let domain = newDomain.trimmingCharacters(in: .whitespaces).lowercased()
        guard !domain.isEmpty, !blockedDomains.contains(domain) else { return }

        blockedDomains.append(domain)
        PreferencesManager.shared.setBlockedDomains(blockedDomains)
        newDomain = ""
    }

    private func removeDomain(_ domain: String) {
        blockedDomains.removeAll { $0 == domain }
        PreferencesManager.shared.setBlockedDomains(blockedDomains)
    }
}

// MARK: - App List Item

struct AppListItemView: View {
    @Binding var app: App

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.body)

                Text(app.id)
                    .font(.caption)
                    .foregroundColor(.secondary)

                if app.category == .essential {
                    Text("Cannot be blocked")
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            }

            Spacer()

            if app.category != .essential {
                Toggle("Block when shifted", isOn: $app.isBlockedWhenShifted)
                    .onChange(of: app.isBlockedWhenShifted) { _ in
                        saveApps()
                    }
            }
        }
        .padding()
    }

    private func saveApps() {
        // This will be called by parent view
        PreferencesManager.shared.saveApps([app])
    }
}

// Add allCases to AppCategory
extension App.AppCategory: CaseIterable {}

#Preview {
    SettingsView()
        .frame(width: 800, height: 600)
}
