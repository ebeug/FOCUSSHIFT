//
//  App.swift
//  FocusShift
//
//  Represents an app installed on the iPhone
//

import Foundation

struct App: Identifiable, Codable, Hashable {
    let id: String                      // Bundle ID (e.g., "com.burbn.instagram")
    let name: String                    // Display name (e.g., "Instagram")
    var iconData: Data?                 // App icon (optional, for future use)
    var category: AppCategory           // What type of app is this?
    var isBlockedWhenShifted: Bool      // Should this app be hidden when shifted?

    enum AppCategory: String, Codable {
        case essential      // Can't be blocked (Phone, Messages, Settings)
        case productivity   // Available by default (Notes, Calendar, Banking)
        case social         // Blocked by default (Instagram, Twitter, Facebook)
        case entertainment  // Blocked by default (YouTube, Netflix, TikTok)
        case games          // Blocked by default (Any games)
        case uncategorized  // User decides

        var displayName: String {
            switch self {
            case .essential:
                return "Essential"
            case .productivity:
                return "Productivity"
            case .social:
                return "Social Media"
            case .entertainment:
                return "Entertainment"
            case .games:
                return "Games"
            case .uncategorized:
                return "Uncategorized"
            }
        }

        // Is this category blocked by default when shifting?
        var isBlockedByDefault: Bool {
            switch self {
            case .social, .entertainment, .games:
                return true
            case .essential, .productivity, .uncategorized:
                return false
            }
        }
    }
}
