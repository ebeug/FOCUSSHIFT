//
//  PreferencesManager.swift
//  FocusShift
//
//  Manages local storage using UserDefaults
//

import Foundation

class PreferencesManager {
    static let shared = PreferencesManager()

    private let defaults = UserDefaults.standard

    // Keys for UserDefaults storage
    private enum Keys {
        static let blockedApps = "blockedApps"
        static let blockedDomains = "blockedDomains"
        static let customApps = "customApps"
        static let focusSession = "focusSession"
        static let schedules = "schedules"
    }

    // MARK: - Blocked Apps

    func getBlockedApps() -> [String] {
        if let saved = defaults.array(forKey: Keys.blockedApps) as? [String] {
            return saved
        }
        // Return default blocked apps
        return DefaultApps.defaultBlockedBundleIDs
    }

    func setBlockedApps(_ apps: [String]) {
        defaults.set(apps, forKey: Keys.blockedApps)
    }

    // MARK: - Blocked Domains

    func getBlockedDomains() -> [String] {
        if let saved = defaults.array(forKey: Keys.blockedDomains) as? [String] {
            return saved
        }
        // Return default blocked domains
        return DefaultApps.defaultBlockedDomains
    }

    func setBlockedDomains(_ domains: [String]) {
        defaults.set(domains, forKey: Keys.blockedDomains)
    }

    // MARK: - Custom Apps

    func saveApps(_ apps: [App]) {
        if let encoded = try? JSONEncoder().encode(apps) {
            defaults.set(encoded, forKey: Keys.customApps)
        }
    }

    func loadApps() -> [App]? {
        guard let data = defaults.data(forKey: Keys.customApps) else { return nil }
        return try? JSONDecoder().decode([App].self, from: data)
    }

    // MARK: - Focus Session

    func saveFocusSession(_ session: FocusSession) {
        if let encoded = try? JSONEncoder().encode(session) {
            defaults.set(encoded, forKey: Keys.focusSession)
        }
    }

    func loadFocusSession() -> FocusSession? {
        guard let data = defaults.data(forKey: Keys.focusSession) else { return nil }
        guard let session = try? JSONDecoder().decode(FocusSession.self, from: data) else {
            return nil
        }
        // Only return if still active
        return session.isActive ? session : nil
    }

    func clearFocusSession() {
        defaults.removeObject(forKey: Keys.focusSession)
    }

    // MARK: - Schedules

    func saveSchedules(_ schedules: [Schedule]) {
        if let encoded = try? JSONEncoder().encode(schedules) {
            defaults.set(encoded, forKey: Keys.schedules)
        }
    }

    func loadSchedules() -> [Schedule] {
        guard let data = defaults.data(forKey: Keys.schedules) else { return [] }
        return (try? JSONDecoder().decode([Schedule].self, from: data)) ?? []
    }

    // MARK: - Clear All Data

    func clearAllData() {
        defaults.removeObject(forKey: Keys.blockedApps)
        defaults.removeObject(forKey: Keys.blockedDomains)
        defaults.removeObject(forKey: Keys.customApps)
        defaults.removeObject(forKey: Keys.focusSession)
        defaults.removeObject(forKey: Keys.schedules)
    }
}
