//
//  AppManager.swift
//  FocusShift
//
//  Manages app categorization and customization
//

import Foundation

class AppManager {
    static let shared = AppManager()

    /// Categorize an app based on its bundle ID
    func categorizeApp(bundleID: String) -> BlockedApp.AppCategory {
        // Check essential apps (can't be blocked)
        if DefaultApps.essentialBundleIDs.contains(bundleID) {
            return .essential
        }

        // Check social media apps
        if DefaultApps.socialBundleIDs.contains(bundleID) {
            return .social
        }

        // Check entertainment apps
        if DefaultApps.entertainmentBundleIDs.contains(bundleID) {
            return .entertainment
        }

        // Check productivity apps
        if DefaultApps.productivityBundleIDs.contains(bundleID) {
            return .productivity
        }

        // Check games
        if DefaultApps.gamesBundleIDs.contains(bundleID) {
            return .games
        }

        // Default to uncategorized
        return .uncategorized
    }

    /// Group apps by category
    func groupAppsByCategory(_ apps: [BlockedApp]) -> [BlockedApp.AppCategory: [BlockedApp]] {
        Dictionary(grouping: apps, by: { $0.category })
    }
}

// MARK: - Default App Lists

struct DefaultApps {
    // Essential apps that can never be blocked
    static let essentialBundleIDs: Set<String> = [
        "com.apple.mobilephone",        // Phone
        "com.apple.MobileSMS",          // Messages
        "com.apple.Preferences",        // Settings
        "com.apple.camera",             // Camera
    ]

    // Social media apps (blocked by default)
    static let socialBundleIDs: Set<String> = [
        "com.burbn.instagram",          // Instagram
        "com.atebits.Tweetie2",         // Twitter/X
        "com.zhiliaoapp.musically",     // TikTok
        "com.facebook.Facebook",        // Facebook
        "com.snapchat.snapchat",        // Snapchat
        "com.reddit.Reddit",            // Reddit
        "com.linkedin.LinkedIn",        // LinkedIn
        "com.discord",                  // Discord
    ]

    // Entertainment apps (blocked by default)
    static let entertainmentBundleIDs: Set<String> = [
        "com.google.ios.youtube",       // YouTube
        "com.netflix.Netflix",          // Netflix
        "com.hulu.plus",                // Hulu
        "com.disney.disneyplus",        // Disney+
        "tv.twitch",                    // Twitch
        "com.hbo.hbonow",               // HBO Max
    ]

    // Productivity apps (available by default)
    static let productivityBundleIDs: Set<String> = [
        "com.apple.mobilenotes",        // Notes
        "com.apple.reminders",          // Reminders
        "com.apple.mobilecal",          // Calendar
        "com.apple.mobilemail",         // Mail
        "com.apple.Maps",               // Maps
        "com.apple.Music",              // Music
        "com.apple.Health",             // Health
        "com.apple.mobilesafari",       // Safari
    ]

    // Games (blocked by default)
    static let gamesBundleIDs: Set<String> = [
        "com.rovio.angrybirds",         // Example game
        // Add more as needed
    ]

    // Default list of apps to block (social + entertainment)
    static let defaultBlockedBundleIDs: [String] = Array(socialBundleIDs) + Array(entertainmentBundleIDs)

    // Default list of domains to block
    static let defaultBlockedDomains: [String] = [
        "instagram.com",
        "twitter.com",
        "x.com",
        "tiktok.com",
        "facebook.com",
        "youtube.com",
        "netflix.com",
        "reddit.com",
        "snapchat.com",
    ]
}
