//
//  ProfileGenerator.swift
//  FocusShift
//
//  Generates Apple Configuration Profiles (mobileconfig XML files)
//

import Foundation

struct ProfileGenerator {

    /// Creates a configuration profile with app and domain restrictions
    static func createRestrictionsProfile(blockedApps: [String], blockedDomains: [String]) -> String {
        // Generate a unique UUID for this profile
        let uuid = UUID().uuidString

        // Build the blacklisted apps array
        let appsXML = blockedApps.map { bundleID in
            "        <string>\(bundleID)</string>"
        }.joined(separator: "\n")

        // Build the blocked domains array
        let domainsXML = blockedDomains.map { domain in
            "            <string>\(domain)</string>"
        }.joined(separator: "\n")

        // Generate the complete mobileconfig XML
        return """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PayloadContent</key>
    <array>
        <!-- App Restrictions Payload -->
        <dict>
            <key>PayloadType</key>
            <string>com.apple.applicationaccess</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
            <key>PayloadIdentifier</key>
            <string>com.focusshift.restrictions.apps</string>
            <key>PayloadUUID</key>
            <string>\(UUID().uuidString)</string>
            <key>PayloadDisplayName</key>
            <string>App Restrictions</string>
            <key>blacklistedAppBundleIDs</key>
            <array>
\(appsXML)
            </array>
        </dict>

        <!-- Safari Content Filter Payload -->
        <dict>
            <key>PayloadType</key>
            <string>com.apple.webcontent-filter</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
            <key>PayloadIdentifier</key>
            <string>com.focusshift.restrictions.webfilter</string>
            <key>PayloadUUID</key>
            <string>\(UUID().uuidString)</string>
            <key>ContentFilterUUID</key>
            <string>\(UUID().uuidString)</string>
            <key>PayloadDisplayName</key>
            <string>Web Content Filter</string>
            <key>FilterType</key>
            <string>BuiltIn</string>
            <key>AutoFilterEnabled</key>
            <false/>
            <key>PermittedURLs</key>
            <array/>
            <key>WhitelistedBookmarks</key>
            <array/>
            <key>UserDefinedName</key>
            <string>FocusShift Web Filter</string>
            <key>FilterDataProviderBundleIdentifier</key>
            <string>com.apple.ManagedConfiguration.ManagedContentFilter</string>
            <key>PluginBundleID</key>
            <string>com.apple.ManagedConfiguration.ManagedContentFilter</string>
            <key>VendorConfig</key>
            <dict>
                <key>FilterBrowsers</key>
                <true/>
                <key>FilterSockets</key>
                <true/>
                <key>UserDefinedBlockList</key>
                <array>
\(domainsXML)
                </array>
            </dict>
        </dict>
    </array>

    <key>PayloadDisplayName</key>
    <string>FocusShift Restrictions</string>
    <key>PayloadDescription</key>
    <string>Restricts distracting apps and websites when in focus mode</string>
    <key>PayloadIdentifier</key>
    <string>com.focusshift.restrictions</string>
    <key>PayloadRemovalDisallowed</key>
    <true/>
    <key>PayloadType</key>
    <string>Configuration</string>
    <key>PayloadUUID</key>
    <string>\(uuid)</string>
    <key>PayloadVersion</key>
    <integer>1</integer>
</dict>
</plist>
"""
    }
}
