# FocusShift

> **One-line description**: A Mac app that transforms your iPhone into a distraction-free tool by blocking social media and distracting apps at the push of a button, using Apple's device supervision.

## 🎯 Product Vision

### What We're Building

FocusShift is a personal productivity tool that solves the smartphone addiction problem without forcing you to buy a dumbphone. It's a sleek macOS application that lets you "shift" your iPhone between two modes: full smartphone (all apps available) and focus mode (only essential apps available). The shift happens instantly with one click from your Mac.

Unlike Screen Time or apps like Opal that can be easily bypassed, FocusShift uses Apple's device supervision technology to make app restrictions truly unbreakable. When your phone is "shifted," distracting apps literally disappear from your home screen and can't be accessed - no willpower required. The system is designed to be simple, beautiful, and impossible to circumvent during a focus session.

This is a personal-use app built for you to reclaim your attention. It's free, minimal, and focused on doing one thing exceptionally well: giving you control over when you can and cannot use distracting apps.

### Target User

**You** - a problem solver who recognizes smartphone addiction is real but doesn't want to abandon the genuinely useful features of a modern iPhone. You want GPS, banking, music, photos, and productivity apps, but you need a hard boundary against infinite scrolling on social media. You're willing to set up a technical solution once in exchange for permanent peace of mind.

### Key Differentiator

FocusShift is the only solution that:
- **Cannot be bypassed** - Uses Apple's supervision which prevents app installation/removal without the Mac app
- **Keeps essentials** - Unlike a dumbphone, you retain banking, maps, music, health apps, etc.
- **Blocks Safari workarounds** - Instagram.com on Safari is also blocked, not just the app
- **Simple and free** - No subscriptions, no accounts, no complexity
- **Built for personal use** - Not a commercial product, just a tool that works

---

## ✨ Core Features

### 1. One-Click Shift/Unshift
**What it does**: A prominent button in the Mac app that instantly puts your iPhone into "focus mode" (distracting apps hidden) or brings it back to "normal mode" (all apps accessible).

**Why it matters**: This is the core value - instant transformation of your phone's capabilities with zero friction. No complicated menus, no settings to fiddle with. Just click and your phone changes.

**How it works**: The Mac app sends a configuration profile update to your supervised iPhone via the cfgutil command-line tool (part of Apple Configurator). This profile includes restrictions that hide specific apps. The iPhone applies the profile immediately over WiFi. When you unshift, it removes those restrictions.

### 2. Smart App Filtering
**What it does**: Automatically blocks social media and entertainment apps (Instagram, TikTok, Twitter/X, Facebook, YouTube, Netflix, etc.) while keeping essential apps available (Messages, Phone, Maps, Banking, Spotify, Camera, Health apps, etc.). The filtering is intelligent - it knows which apps are tools vs. distractions.

**Why it matters**: You don't want to manually configure every app. The system should just know that Instagram is a time sink but Apple Maps is essential. Default smart filtering means the app works immediately without configuration.

**How it works**: The app contains a hardcoded list of bundle identifiers for known distracting apps. When shifted, these bundle IDs are added to the restriction profile. Initially ships with a curated list of common distractions. You can customize this later (see feature #3).

### 3. Custom Whitelist/Blacklist
**What it does**: Lets you customize which apps get blocked when shifted. By default, all known distracting apps are blocked, but you can whitelist specific ones (maybe you need YouTube for work) or blacklist additional ones (maybe you find yourself compulsively checking weather apps).

**Why it matters**: Everyone's relationship with apps is different. You might need access to Reddit for work communities, or you might find yourself doom-scrolling Apple News. Customization makes the tool adapt to your needs.

**How it works**: The Mac app shows a list of all apps installed on your iPhone (fetched via cfgutil list-apps). Each app has a toggle: "Block when shifted" or "Allow when shifted". The app categories are:
- **Always Available** (Phone, Messages, Settings) - Can't be blocked
- **Default Blocked** (Social media, games) - Blocked unless whitelisted
- **Default Available** (Banking, maps, health) - Available unless blacklisted
- **Uncategorized** (User apps) - You decide

### 4. Safari Content Filtering
**What it does**: Blocks social media websites in Safari when shifted. So instagram.com, twitter.com, tiktok.com, etc. can't be accessed as a workaround to the blocked apps.

**Why it matters**: The #1 way people bypass app blockers is by using the mobile website. If Instagram.com works in Safari, the app block is meaningless. Content filtering closes this loophole.

**How it works**: Uses Apple's Content Filter restrictions in the configuration profile. The profile includes a list of blocked domains that gets pushed to the device. Safari (and all browsers) on iOS respect these restrictions when the device is supervised.

### 5. Focus Sessions
**What it does**: Allows you to lock your phone in shifted mode for a set duration (30 min, 60 min, 90 min) during which you CANNOT unshift, even from the Mac app. The only way out is to wait or emergency unsupervise.

**Why it matters**: Sometimes you need to force future-you to stay focused. If you can always unshift instantly, you'll do it impulsively. Focus sessions add a commitment mechanism - you declare "I'm focused for the next hour" and the system holds you to it.

**How it works**: When you start a focus session, the Mac app sets a local timer and disables the Unshift button. It also stores the session end time. Even if you restart the Mac app, it checks the stored session end time and keeps the Unshift button disabled until the timer expires. The iPhone remains shifted for the duration.

### 6. Automatic Scheduling
**What it does**: Automatically shifts your phone at specified times. For example, shift every weeknight at 9pm (wind-down time) and unshift at 7am (morning routine). Or shift during work hours (9am-5pm Mon-Fri).

**Why it matters**: The best habits are automated. If you manually have to remember to shift your phone every evening, you'll forget or make excuses. Scheduling makes focus the default, not an exception.

**How it works**: The Mac app stores a list of scheduled shift/unshift times. A background process runs every minute checking if it's time to shift or unshift. If the current time matches a scheduled time, it executes the shift/unshift command via cfgutil. Schedules include:
- Daily recurring (e.g., "Every day at 9pm")
- Weekday only (e.g., "Monday-Friday at 9am") 
- Weekend only
- Custom day selections

### 7. Emergency Unsupervise
**What it does**: A clearly marked "Emergency: Remove All Restrictions" button that completely removes supervision from your iPhone and restores it to factory configuration capabilities.

**Why it matters**: **CRITICAL FOR SAFETY** - You're a beginner building this, and you need a way out if something goes wrong. Also, you might decide to stop using FocusShift, sell your phone, or travel internationally and need full control back. This button should be accessible at all times.

**How it works**: Runs the cfgutil command to remove supervision: `cfgutil remove-supervision`. This completely removes the supervision profile and restores the iPhone to normal operation. After this, FocusShift can't control the phone anymore until you re-supervise it. This action requires confirmation ("Are you SURE? This will disable FocusShift entirely until you re-supervise your device.").

---

## 🎨 User Experience

### User Journey

1. **Initial Setup** → Download FocusShift Mac app, connect iPhone via cable, click "Supervise My iPhone", follow prompts (disable Find My, trust computer), wait 2-3 minutes for supervision setup
2. **First Shift** → Click "Shift iPhone" button, watch real-time status ("Applying restrictions..."), see success confirmation, pick up iPhone and notice social media apps have disappeared
3. **Daily Use** → Open Mac app whenever you want to focus, click Shift, work distraction-free, click Unshift when you're done
4. **Customize (Optional)** → Go to Settings tab, see list of your apps, toggle which ones get blocked, save preferences
5. **Schedule (Optional)** → Add automatic shift schedule for evenings, set it and forget it

### Key Screens/Pages

#### Main Control Screen
**Purpose**: The primary interface - one-click access to shift/unshift your iPhone.

**Layout**: 
- Centered card design with a large primary button
- Top bar shows iPhone connection status ("Connected via WiFi" / "Not Connected")
- Main card takes up 60% of window height, centered
- Bottom section shows current schedule (if any) and next scheduled action

**Components**:
- **Status Indicator**: 
  - Green dot + "Connected - iPhone [Your Name]" (when iPhone detected)
  - Orange dot + "Searching for iPhone..." (when searching)
  - Red dot + "iPhone not found" (when disconnected)
  - Shows last shift status: "Phone is Unshifted (all apps available)" or "Phone is Shifted (focus mode active)"
  
- **Primary Action Button**:
  - HUGE button, 240px wide x 80px tall
  - When unshifted: Blue background, "Shift iPhone" text with moon icon 🌙
  - When shifted: Purple background, "Unshift iPhone" text with sparkle icon ✨
  - During transition: Gray, "Shifting..." or "Unshifting..." with spinner
  - Disabled during focus session (shows countdown)
  
- **Focus Session Selector**:
  - Below main button, horizontally arranged pills
  - "No Timer" (default) | "30 min" | "60 min" | "90 min"
  - Selected option is highlighted
  - When clicked, shifts and starts countdown
  
- **Schedule Preview**:
  - Small card at bottom showing: "Next scheduled: Shift at 9:00 PM today"
  - Click to jump to Schedule tab

**User Actions**:
- Click main button → Shifts or unshifts iPhone, shows progress, confirms success
- Select focus session duration → Shifts iPhone and locks unshift for that duration
- Click schedule preview → Opens Schedule tab

#### Settings / App Management Screen
**Purpose**: Customize which apps are blocked when shifted.

**Layout**:
- Sidebar on left (30% width) with categories
- Main area (70% width) shows apps in selected category
- Search bar at top of main area

**Components**:
- **Category Sidebar**:
  - "Social Media" (count) - Default blocked
  - "Entertainment" (count) - Default blocked  
  - "Productivity" (count) - Default available
  - "Essentials" (count) - Always available
  - "Games" (count) - Default blocked
  - "Uncategorized" (count) - Your choice
  
- **App List**:
  - Each app shows: Icon, Name, Bundle ID (small gray text)
  - Toggle switch on right: "Block when shifted" (on/off)
  - Default state shown in light gray text ("Default: Blocked" / "Default: Available")
  - Search filters the list instantly
  
- **Sync Button**:
  - "Refresh App List" button at top - fetches latest installed apps from iPhone
  - Shows spinning indicator while syncing
  
- **Blocked Domains Section**:
  - Below app list, a separate card titled "Blocked Websites"
  - List of domains that are blocked in Safari (instagram.com, twitter.com, etc.)
  - Add/remove buttons to customize the list
  - Pre-filled with common social media domains

**User Actions**:
- Click category → Filters app list to that category
- Toggle app → Changes whether it's blocked when shifted, immediately saves
- Click Refresh → Re-fetches installed apps from iPhone
- Add domain → Adds new website to block list
- Remove domain → Removes website from block list

#### Schedule Screen
**Purpose**: Set up automatic shift/unshift times.

**Layout**:
- List of schedule rules (if any) in cards
- Large "Add Schedule" button at top
- Each rule is an editable card

**Components**:
- **Schedule Rule Card**:
  - Shows: "Shift at 9:00 PM" and "Unshift at 7:00 AM"
  - Days selector: M T W T F S S (clickable pills, selected days highlighted)
  - Toggle: "Enabled" / "Disabled"
  - Delete button (trash icon)
  
- **Add Schedule Modal**:
  - Opens when clicking "Add Schedule"
  - Action dropdown: "Shift" or "Unshift"
  - Time picker: Hour and minute
  - Day selector: All days / Weekdays / Weekends / Custom
  - Save / Cancel buttons

**User Actions**:
- Click Add Schedule → Opens modal to create new rule
- Fill in time and days → Creates schedule rule
- Toggle enabled/disabled → Turns rule on/off without deleting
- Click delete → Removes schedule rule with confirmation

#### Emergency Panel (Always Accessible)
**Purpose**: Provide safety valves - emergency unsupervise and manual unsupervise.

**Layout**:
- Small warning-colored panel at bottom of every screen
- Expandable section (collapsed by default)

**Components**:
- **Danger Zone (Collapsed)**:
  - Small red/orange badge that says "Emergency Options" with caret icon
  
- **Danger Zone (Expanded)**:
  - "Emergency: Remove All Supervision" button - bright red
  - Explanation text: "This will completely remove FocusShift's control over your iPhone. Use this if something goes wrong or you want to stop using FocusShift. You'll need to re-supervise to use the app again."
  - Requires typing "REMOVE" to confirm
  
- **Manual Override** (only visible during focus session):
  - "I understand the consequences: Disable Focus Session" button - orange
  - Requires confirmation

**User Actions**:
- Click Emergency Options → Expands the danger zone
- Click Remove All Supervision → Prompts for confirmation, then unsupervises device
- Click Disable Focus Session → Confirms, then ends the session early

---

## 🏗️ Technical Architecture

### Tech Stack

**Frontend (macOS App)**:
- **Swift + SwiftUI** - Native macOS app development. SwiftUI provides modern declarative UI that's perfect for the clean, minimal aesthetic you want. Swift is the standard for Mac apps and has great system integration.
- **Combine Framework** - For reactive UI updates and handling async operations like checking shift status and timers
- **UserDefaults** - For storing user preferences, app lists, schedules, and current state. Simple and sufficient for a single-user app with no backend.

**System Integration**:
- **cfgutil** (Apple Configurator command-line tool) - This is THE key technology. It's a command-line tool that comes with Apple Configurator and allows you to:
  - Supervise/unsupervise devices
  - Install/remove configuration profiles
  - Query device status and installed apps
  - All without needing to build a full MDM server
- **Configuration Profiles (mobileconfig format)** - XML-based profiles that define device restrictions. The Mac app generates these profiles dynamically based on which apps should be blocked, then uses cfgutil to install them.

**No Backend Needed**:
- Everything runs locally on your Mac
- No user accounts, no server, no API
- The Mac app communicates directly with your iPhone via USB (initial setup) and WiFi (ongoing control)

### Project Structure

```
FocusShift/
├── FocusShift/                          # Main app target
│   ├── FocusShiftApp.swift             # App entry point
│   ├── ContentView.swift               # Main tab container
│   ├── Views/
│   │   ├── ControlView.swift           # Main shift/unshift screen
│   │   ├── SettingsView.swift          # App management screen
│   │   ├── ScheduleView.swift          # Scheduling screen
│   │   └── Components/
│   │       ├── StatusIndicator.swift   # Connection status component
│   │       ├── ShiftButton.swift       # Main action button
│   │       ├── FocusSessionPicker.swift # Timer selection
│   │       ├── AppListItem.swift       # App row with toggle
│   │       └── EmergencyPanel.swift    # Danger zone component
│   ├── Models/
│   │   ├── iPhoneDevice.swift          # Device state model
│   │   ├── App.swift                   # Installed app model
│   │   ├── Schedule.swift              # Schedule rule model
│   │   └── FocusSession.swift          # Active session model
│   ├── Services/
│   │   ├── DeviceManager.swift         # Talks to cfgutil
│   │   ├── ProfileGenerator.swift      # Creates mobileconfig files
│   │   ├── ScheduleManager.swift       # Handles scheduled shifts
│   │   └── PreferencesManager.swift    # UserDefaults wrapper
│   └── Resources/
│       ├── Assets.xcassets/            # App icons and images
│       └── DefaultApps.json            # Default block/allow lists
├── cfgutil-wrapper/                     # Helper scripts
│   └── cfgutil-commands.sh             # Shell script wrappers
└── FocusShift.xcodeproj                # Xcode project
```

### Key Components & Data Flow

#### How Shifting Works (Technical Flow)

1. **User clicks "Shift iPhone"**
   - `ControlView` calls `DeviceManager.shiftDevice()`
   
2. **Generate Configuration Profile**
   - `ProfileGenerator` creates a mobileconfig XML file with:
     - App restrictions (bundle IDs to hide)
     - Safari content filter (domains to block)
     - Device identification
   - Saves to temp directory: `/tmp/focusshift-restrict.mobileconfig`
   
3. **Apply Profile to iPhone**
   - `DeviceManager` runs shell command:
     ```bash
     cfgutil install-profile /tmp/focusshift-restrict.mobileconfig
     ```
   - cfgutil communicates with iPhone over WiFi (if paired) or USB
   - iPhone receives profile and applies restrictions immediately
   
4. **Update UI**
   - `DeviceManager` publishes state change via Combine
   - `ControlView` updates to show "Shifted" state with Unshift button
   - Status indicator shows green "Phone is Shifted"

#### How Unshifting Works

1. **User clicks "Unshift iPhone"** (or timer expires)
   - `ControlView` calls `DeviceManager.unshiftDevice()`
   
2. **Remove Configuration Profile**
   - `DeviceManager` runs shell command:
     ```bash
     cfgutil remove-profile com.focusshift.restrictions
     ```
   - The profile is identified by its unique ID
   - iPhone removes restrictions immediately
   
3. **Update UI**
   - State updates to "Unshifted"
   - Button changes to "Shift iPhone"
   - All apps reappear on iPhone

#### Focus Sessions

- When starting a focus session with timer:
  - Shift the device normally
  - Store session end time in `UserDefaults`: `focusSessionEndsAt = Date() + duration`
  - Disable Unshift button in UI
  - Start a Timer that fires every second to update countdown display
  
- The Unshift button checks:
  ```swift
  var canUnshift: Bool {
      guard let endsAt = PreferencesManager.focusSessionEndsAt else {
          return true // No active session
      }
      return Date() > endsAt // Session expired
  }
  ```
  
- When timer expires:
  - Clear stored end time
  - Re-enable Unshift button
  - Show notification "Focus session complete! 🎉"

#### Scheduled Shifts

- `ScheduleManager` runs a background timer (every 60 seconds)
- On each tick, checks all enabled schedules:
  ```swift
  for schedule in enabledSchedules {
      if schedule.shouldTriggerNow() {
          if schedule.action == .shift {
              DeviceManager.shiftDevice()
          } else {
              DeviceManager.unshiftDevice()
          }
      }
  }
  ```
- Schedules are stored in UserDefaults as JSON

### Configuration Profile Structure

The generated mobileconfig file looks like this (simplified):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PayloadContent</key>
    <array>
        <!-- App Restrictions -->
        <dict>
            <key>PayloadType</key>
            <string>com.apple.applicationaccess</string>
            <key>blacklistedAppBundleIDs</key>
            <array>
                <string>com.burbn.instagram</string>
                <string>com.atebits.Tweetie2</string>
                <string>com.zhiliaoapp.musically</string>
                <!-- ... more blocked apps -->
            </array>
        </dict>
        
        <!-- Safari Content Filter -->
        <dict>
            <key>PayloadType</key>
            <string>com.apple.webcontent-filter</string>
            <key>FilterType</key>
            <string>BuiltIn</string>
            <key>FilterSockets</key>
            <true/>
            <key>FilterDataProviderBundleIdentifier</key>
            <string>com.apple.ManagedConfiguration.ManagedContentFilter</string>
            <key>FilterDataProviderDesignatedRequirement</key>
            <string>...</string>
            <key>VendorConfig</key>
            <dict>
                <key>FilterBrowsers</key>
                <true/>
                <key>FilterSockets</key>
                <true/>
                <key>UserDefinedBlockList</key>
                <array>
                    <string>instagram.com</string>
                    <string>twitter.com</string>
                    <string>tiktok.com</string>
                    <!-- ... more blocked domains -->
                </array>
            </dict>
        </dict>
    </array>
    <key>PayloadDisplayName</key>
    <string>FocusShift Restrictions</string>
    <key>PayloadIdentifier</key>
    <string>com.focusshift.restrictions</string>
    <key>PayloadRemovalDisallowed</key>
    <true/>
    <key>PayloadType</key>
    <string>Configuration</string>
    <key>PayloadUUID</key>
    <string>[UNIQUE-UUID]</string>
    <key>PayloadVersion</key>
    <integer>1</integer>
</dict>
</plist>
```

### App Models

```swift
// Models/iPhoneDevice.swift
struct iPhoneDevice: Identifiable {
    let id: String  // UDID
    let name: String
    var isConnected: Bool
    var isShifted: Bool
    var lastSeenAt: Date
}

// Models/App.swift
struct App: Identifiable, Codable {
    let id: String  // Bundle ID
    let name: String
    var iconData: Data?
    var category: AppCategory
    var isBlockedWhenShifted: Bool
    
    enum AppCategory: String, Codable {
        case essential      // Can't be blocked
        case productivity   // Available by default
        case social         // Blocked by default
        case entertainment  // Blocked by default
        case games          // Blocked by default
        case uncategorized  // User decides
    }
}

// Models/Schedule.swift
struct Schedule: Identifiable, Codable {
    let id: UUID
    var action: ScheduleAction  // .shift or .unshift
    var time: DateComponents    // Hour and minute
    var days: Set<Weekday>      // Which days to run
    var isEnabled: Bool
    
    enum ScheduleAction: String, Codable {
        case shift
        case unshift
    }
    
    enum Weekday: Int, Codable {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
    
    func shouldTriggerNow() -> Bool {
        // Check if current time matches schedule time and day
    }
}

// Models/FocusSession.swift
struct FocusSession: Codable {
    let startedAt: Date
    let endsAt: Date
    var isActive: Bool {
        Date() < endsAt
    }
    var remainingSeconds: Int {
        max(0, Int(endsAt.timeIntervalSince(Date())))
    }
}
```

### Key Services

#### DeviceManager

```swift
class DeviceManager: ObservableObject {
    @Published var connectedDevice: iPhoneDevice?
    @Published var isShifted: Bool = false
    @Published var isProcessing: Bool = false
    
    private let cfgutilPath = "/Applications/Apple Configurator.app/Contents/MacOS/cfgutil"
    
    // Check if iPhone is connected
    func detectDevice() async throws -> iPhoneDevice? {
        let output = try await runCommand("\(cfgutilPath) list")
        // Parse output to extract device info
        return parseDeviceInfo(output)
    }
    
    // Apply restrictions (shift)
    func shiftDevice() async throws {
        isProcessing = true
        defer { isProcessing = false }
        
        let profile = ProfileGenerator.createRestrictionsProfile(
            blockedApps: PreferencesManager.getBlockedApps(),
            blockedDomains: PreferencesManager.getBlockedDomains()
        )
        
        let profilePath = "/tmp/focusshift-restrict.mobileconfig"
        try profile.write(to: URL(fileURLWithPath: profilePath))
        
        try await runCommand("\(cfgutilPath) install-profile \(profilePath)")
        
        isShifted = true
    }
    
    // Remove restrictions (unshift)
    func unshiftDevice() async throws {
        isProcessing = true
        defer { isProcessing = false }
        
        try await runCommand("\(cfgutilPath) remove-profile com.focusshift.restrictions")
        
        isShifted = false
    }
    
    // Get list of installed apps
    func fetchInstalledApps() async throws -> [App] {
        let output = try await runCommand("\(cfgutilPath) list-apps")
        return parseAppList(output)
    }
    
    // Emergency: Remove supervision entirely
    func removeSuperv supervision() async throws {
        try await runCommand("\(cfgutilPath) remove-supervision")
        connectedDevice = nil
        isShifted = false
    }
    
    // Helper to run shell commands
    private func runCommand(_ command: String) async throws -> String {
        // Execute shell command and return output
        // Implementation using Process()
    }
}
```

---

## 📝 Implementation Guide

### Phase 1: Project Setup & cfgutil Integration (Start Here!)

**Goal**: Create a basic Mac app that can detect your iPhone and run cfgutil commands successfully.

**Tasks**:

1. **Install Prerequisites**
   - Download and install **Xcode** from the Mac App Store (15GB, takes a while!)
   - Download and install **Apple Configurator** from the Mac App Store
   - Verify cfgutil is available:
     ```bash
     /Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil version
     ```
     Should print: `Apple Configurator command-line utility version X.X`

2. **Initial iPhone Setup (ONE-TIME SETUP - THIS IS CRITICAL)**
   - Connect your iPhone via USB cable to your Mac
   - Open Apple Configurator app
   - In Apple Configurator, select your iPhone
   - Click "Prepare" from the top menu
   - Choose "Manual Configuration"
   - **IMPORTANT**: Before proceeding, back up your iPhone via iTunes/Finder!
   - On your iPhone:
     - Go to Settings > Face ID & Passcode (or Touch ID & Passcode)
     - Turn OFF "Find My iPhone"
     - You'll need to enter your Apple ID password
   - Back in Apple Configurator:
     - Click "Prepare" and follow prompts
     - Choose "Do not enroll in MDM"
     - Choose "Supervise devices"
     - Create a supervision identity (just a name, like "Personal")
     - Wait for preparation to complete (2-5 minutes)
   - After setup, your iPhone will show "This iPhone is supervised" in Settings > General > About
   - **You can now re-enable Find My iPhone** - supervision persists

3. **Create Xcode Project**
   - Open Xcode
   - File > New > Project
   - Choose "macOS" > "App"
   - Product Name: "FocusShift"
   - Interface: SwiftUI
   - Language: Swift
   - Create project in a location you'll remember

4. **Test cfgutil from Swift**
   - Create `Services/DeviceManager.swift`
   - Implement basic command execution using Process()
   - Test with simple command: `cfgutil list`
   - Display result in UI to confirm iPhone is detected
   - Example basic test code:
     ```swift
     let process = Process()
     process.executableURL = URL(fileURLWithPath: "/Applications/Apple Configurator.app/Contents/MacOS/cfgutil")
     process.arguments = ["list"]
     let pipe = Pipe()
     process.standardOutput = pipe
     try process.run()
     process.waitUntilExit()
     let data = pipe.fileHandleForReading.readDataToEndOfFile()
     let output = String(data: data, encoding: .utf8)
     print("iPhone found:", output)
     ```

5. **Create Basic UI Structure**
   - Set up ContentView with tab navigation (Control, Settings, Schedule)
   - Create placeholder views for each tab
   - Add connection status indicator at top
   - Test app runs and tabs switch

**Completion Check**: 
- Xcode project builds without errors
- App launches and shows three tabs
- Running the app shows your iPhone's name in the status indicator
- Clicking a test button successfully runs `cfgutil list` and displays output

**Estimated Time**: 2-3 hours (mostly waiting for Xcode to download and supervising iPhone)

---

### Phase 2: Core Shift/Unshift Functionality

**Goal**: Implement the basic shift/unshift mechanism with hardcoded app list.

**Tasks**:

1. **Create ProfileGenerator Service**
   - New file: `Services/ProfileGenerator.swift`
   - Function: `createRestrictionsProfile(blockedApps: [String], blockedDomains: [String]) -> String`
   - Returns XML string in mobileconfig format
   - Hardcode initial block list:
     ```swift
     let defaultBlockedApps = [
         "com.burbn.instagram",         // Instagram
         "com.atebits.Tweetie2",        // Twitter/X
         "com.zhiliaoapp.musically",    // TikTok
         "com.facebook.Facebook",        // Facebook
         "com.google.ios.youtube",       // YouTube
         "com.netflix.Netflix",          // Netflix
         "com.snapchat.snapchat",        // Snapchat
         "com.reddit.Reddit",            // Reddit
     ]
     let defaultBlockedDomains = [
         "instagram.com",
         "twitter.com",
         "x.com",
         "tiktok.com",
         "facebook.com",
         "youtube.com",
         "netflix.com",
         "reddit.com"
     ]
     ```
   - Use the XML template from the Technical Architecture section above

2. **Implement Shift Logic in DeviceManager**
   - Add `shiftDevice()` function
   - Generate profile XML
   - Write to temporary file
   - Run: `cfgutil install-profile /tmp/focusshift-restrict.mobileconfig`
   - Update `isShifted` state to true
   - Handle errors gracefully

3. **Implement Unshift Logic**
   - Add `unshiftDevice()` function
   - Run: `cfgutil remove-profile com.focusshift.restrictions`
   - Update `isShifted` state to false

4. **Build Main Control View**
   - Create `Views/ControlView.swift`
   - Large "Shift iPhone" / "Unshift iPhone" button
   - Changes appearance based on `isShifted` state
   - Shows loading spinner when `isProcessing` is true
   - Button calls DeviceManager.shiftDevice() or unshiftDevice()

5. **Test on Real iPhone**
   - Run the app
   - Click "Shift iPhone"
   - Pick up your iPhone
   - Confirm Instagram, Twitter, TikTok etc. have disappeared from home screen
   - Try opening instagram.com in Safari - should be blocked
   - Back in Mac app, click "Unshift iPhone"
   - Confirm apps reappear on iPhone

**Completion Check**:
- Clicking "Shift iPhone" makes social media apps disappear from iPhone
- Social media websites are blocked in Safari
- Clicking "Unshift iPhone" brings all apps back
- The button shows the correct state (Shift vs Unshift)
- No crashes or errors during shift/unshift

**Estimated Time**: 3-4 hours

---

### Phase 3: Focus Sessions

**Goal**: Add timer-based focus sessions that prevent unshifting for a set duration.

**Tasks**:

1. **Create FocusSession Model**
   - File: `Models/FocusSession.swift`
   - Properties: startedAt, endsAt, isActive computed property
   - Codable so it can be saved to UserDefaults

2. **Add PreferencesManager**
   - File: `Services/PreferencesManager.swift`
   - Wrapper around UserDefaults
   - Methods:
     - `saveFocusSession(_ session: FocusSession)`
     - `loadFocusSession() -> FocusSession?`
     - `clearFocusSession()`

3. **Update DeviceManager for Sessions**
   - Modify `shiftDevice()` to accept optional duration
   - If duration provided, create FocusSession and save it
   - Add `canUnshift` computed property that checks if session is active

4. **Build Focus Session Picker UI**
   - Component: `Views/Components/FocusSessionPicker.swift`
   - Four buttons: "No Timer", "30 min", "60 min", "90 min"
   - Styled as pills/chips
   - Returns selected duration when clicked

5. **Integrate into ControlView**
   - Add FocusSessionPicker below main shift button
   - When duration selected, call `shiftDevice(duration: duration)`
   - If focus session active, disable Unshift button
   - Show countdown timer: "Session ends in 43:27"
   - Use a Timer that updates every second to show remaining time

6. **Add Manual Override** (in Emergency Panel)
   - Button: "I understand: End Focus Session"
   - Requires confirmation
   - Clears the saved session
   - Re-enables Unshift button

**Completion Check**:
- Can start focus session with 30 min timer
- Unshift button is disabled and shows countdown
- Timer counts down correctly
- When timer hits zero, Unshift button re-enables
- Can manually end session from Emergency Panel
- Session persists if Mac app is quit and reopened

**Estimated Time**: 2-3 hours

---

### Phase 4: Scheduling

**Goal**: Automatically shift/unshift at specified times.

**Tasks**:

1. **Create Schedule Model**
   - File: `Models/Schedule.swift`
   - Properties: id, action (.shift or .unshift), time, days, isEnabled
   - Method: `shouldTriggerNow() -> Bool`

2. **Create ScheduleManager Service**
   - File: `Services/ScheduleManager.swift`
   - Stores schedules in UserDefaults as JSON
   - Methods:
     - `addSchedule(_ schedule: Schedule)`
     - `removeSchedule(id: UUID)`
     - `getAllSchedules() -> [Schedule]`
     - `updateSchedule(_ schedule: Schedule)`
   - Background timer (runs every 60 seconds) that:
     - Loads all enabled schedules
     - Checks if any should trigger now
     - If yes, calls DeviceManager.shiftDevice() or unshiftDevice()

3. **Start Background Timer**
   - In `FocusShiftApp.swift`, start ScheduleManager timer on app launch
   - Timer should run even when app is in background (use NSApplication.shared to keep app running)

4. **Build Schedule View**
   - File: `Views/ScheduleView.swift`
   - List of existing schedules (if empty, show "No schedules yet")
   - Each schedule shows: action, time, days, enabled toggle
   - "Add Schedule" button at top
   - Delete button (trash icon) for each schedule

5. **Build Add/Edit Schedule Modal**
   - Dropdown or Picker: Action (Shift / Unshift)
   - Time picker (hour and minute)
   - Day selector: All Days / Weekdays / Weekends / Custom (with individual day toggles)
   - Save / Cancel buttons
   - Saves to ScheduleManager when Save clicked

6. **Test Scheduling**
   - Create a test schedule for 1 minute in the future
   - Wait and confirm iPhone shifts automatically
   - Create unshift schedule for 2 minutes in future
   - Confirm iPhone unshifts automatically

**Completion Check**:
- Can create schedule rules with time and day selection
- Schedules persist across app restarts
- Scheduled shifts happen automatically at the right time
- Can enable/disable schedules without deleting
- Can delete schedules

**Estimated Time**: 3-4 hours

---

### Phase 5: App Management & Customization

**Goal**: Allow customization of which apps get blocked and whitelist/blacklist management.

**Tasks**:

1. **Fetch Installed Apps from iPhone**
   - In DeviceManager, add `fetchInstalledApps() async throws -> [App]`
   - Runs: `cfgutil list-apps`
   - Parses output to extract bundle IDs and app names
   - Creates App objects with initial category assignment

2. **Create Default Categories JSON**
   - File: `Resources/DefaultApps.json`
   - Contains categorized lists of common apps:
     ```json
     {
       "essential": ["com.apple.mobilephone", "com.apple.MobileSMS", "com.apple.Preferences"],
       "social": ["com.burbn.instagram", "com.atebits.Tweetie2", "com.zhiliaoapp.musically"],
       "entertainment": ["com.google.ios.youtube", "com.netflix.Netflix"],
       "productivity": ["com.apple.mobilenotes", "com.apple.reminders"],
       "games": ["com.rovio.angrybirds"]
     }
     ```
   - Load this on first run to categorize apps

3. **Build App Management Service**
   - File: `Services/AppManager.swift`
   - Loads DefaultApps.json
   - Categorizes installed apps by matching bundle IDs
   - Saves user customizations to UserDefaults
   - Methods:
     - `getAppsByCategory() -> [AppCategory: [App]]`
     - `toggleAppBlockStatus(bundleID: String)`
     - `refreshApps()` - fetches from iPhone

4. **Build Settings View**
   - File: `Views/SettingsView.swift`
   - Two-column layout:
     - Left: Category list (Social Media, Entertainment, Productivity, etc.)
     - Right: Apps in selected category
   - Each app row shows icon (if available), name, and toggle switch
   - Toggle switch labeled "Block when shifted"
   - Default state shown in gray text below app name
   - Search bar at top filters apps by name

5. **Add Blocked Domains Section**
   - Below app list, separate section titled "Blocked Websites"
   - List of domains currently blocked
   - Text field + "Add" button to add new domain
   - Delete button for each domain

6. **Update ProfileGenerator**
   - Modify to use dynamic app list from PreferencesManager instead of hardcoded list
   - Pull blockedApps from user customizations
   - Pull blockedDomains from user customizations

7. **Add "Refresh Apps" Button**
   - Button at top of Settings view
   - Calls DeviceManager.fetchInstalledApps()
   - Shows loading spinner while fetching
   - Merges new apps with existing customizations

**Completion Check**:
- Settings view shows all installed apps grouped by category
- Can toggle apps between blocked/allowed
- Can add custom domains to block list
- Can refresh app list and see newly installed apps
- Customizations persist across app restarts
- Shifting uses the customized block list

**Estimated Time**: 4-5 hours

---

### Phase 6: Polish & Safety Features

**Goal**: Add the emergency unsupervise feature, improve UI, add notifications.

**Tasks**:

1. **Build Emergency Panel Component**
   - File: `Views/Components/EmergencyPanel.swift`
   - Collapsible section (collapsed by default)
   - Bright red "Emergency: Remove All Supervision" button
   - Explanation text about what this does
   - Confirmation dialog that requires typing "REMOVE"
   - Calls DeviceManager.removeSupervision()

2. **Add Emergency Panel to All Screens**
   - Place at bottom of ContentView
   - Always visible as a small banner when collapsed
   - Expands when clicked

3. **Implement removeSupervision()**
   - In DeviceManager
   - Runs: `cfgutil remove-supervision`
   - Shows alert after completion: "Supervision removed. FocusShift can no longer control your iPhone. You'll need to re-supervise to use the app again."
   - Clears all saved state

4. **Add macOS Notifications**
   - Import UserNotifications framework
   - Request notification permission on first launch
   - Send notifications for:
     - "Focus session complete!"
     - "iPhone shifted automatically" (for scheduled shifts)
     - "iPhone unshifted automatically"
     - Errors: "Failed to shift iPhone - is it connected?"

5. **Improve Status Indicator**
   - Component: `Views/Components/StatusIndicator.swift`
   - Shows connection status with colored dot (green/orange/red)
   - Shows iPhone name when connected
   - Shows last shift status: "Phone is Shifted" or "Phone is Unshifted"
   - Animated dot pulse when searching for device

6. **Add Loading States**
   - During shift/unshift, show progress indicator on button
   - Change button text to "Shifting..." or "Unshifting..."
   - Disable button during operation

7. **Design System Colors**
   - Create `Resources/Colors.xcassets`
   - Define colors:
     - Primary: #5B7FFF (calm blue for unshifted)
     - Secondary: #A78BFA (purple for shifted)
     - Success: #10B981 (green)
     - Warning: #F59E0B (orange)
     - Danger: #EF4444 (red)
     - Background: #F9FAFB (light gray)
     - Surface: #FFFFFF (white)

8. **Polish UI**
   - Add SF Symbols icons to buttons
   - Add smooth animations for state changes
   - Consistent padding and spacing (use SwiftUI .padding())
   - Round corners on cards
   - Subtle shadows on main buttons

9. **Error Handling**
   - Wrap all cfgutil commands in try/catch
   - Show user-friendly error alerts
   - Errors to handle:
     - iPhone not found
     - iPhone not supervised
     - Profile installation failed
     - Permission denied
   - Add troubleshooting tips in alerts

**Completion Check**:
- Emergency unsupervise button works and requires confirmation
- Notifications appear when shifts happen
- UI is polished and looks like a modern Mac app
- All buttons show loading states during operations
- Errors are caught and shown to user with helpful messages
- Colors are consistent throughout app

**Estimated Time**: 3-4 hours

---

### Phase 7: Testing & Bug Fixes

**Goal**: Ensure everything works reliably and fix any issues.

**Tasks**:

1. **Test All Features**
   - Manual shift/unshift (10 times in a row)
   - Focus sessions (all three durations)
   - Schedule creation and triggering
   - App customization and persistence
   - Emergency unsupervise and re-supervise
   - App behavior when iPhone disconnects during operation

2. **Test Edge Cases**
   - What if iPhone dies during a focus session?
   - What if Mac goes to sleep during scheduled shift?
   - What if two schedules conflict (shift and unshift at same time)?
   - What if user force-quits the app during a shift operation?
   - What if WiFi connection drops during profile install?

3. **Add Logging**
   - Use `os_log` for debugging
   - Log all cfgutil commands and their outputs
   - Log schedule triggers
   - Helps troubleshoot issues

4. **Create User Documentation**
   - README file with:
     - What FocusShift does
     - How to initially supervise your iPhone
     - Troubleshooting common issues
     - How to completely remove supervision if needed

5. **Performance Testing**
   - Ensure scheduled checks don't use too much CPU
   - Ensure app doesn't drain Mac battery when idle
   - Profile generation should be instant (<100ms)

**Completion Check**:
- All features work reliably
- No crashes during normal use
- Edge cases are handled gracefully
- Documentation exists for setup and troubleshooting

**Estimated Time**: 2-3 hours

---

## 🎯 Important Implementation Notes

### Critical Workflows

**Initial Supervision Setup** (This is the hardest part!):
1. User must disable Find My iPhone and Activation Lock in Settings
2. Connect iPhone to Mac via USB cable
3. Open Apple Configurator (not the FocusShift app)
4. Select iPhone and click "Prepare"
5. Choose "Manual Configuration" (not Automated Device Enrollment)
6. Choose "Do not enroll in MDM"
7. Check "Supervise devices"
8. Create a supervision identity (just a name)
9. Wait for supervision to complete (takes 2-5 minutes, erases device if not already supervised)
10. After setup, user can re-enable Find My iPhone
11. Now FocusShift can control the device!

**Profile Installation Flow**:
1. Generate mobileconfig XML with restrictions
2. Write to `/tmp/focusshift-restrict.mobileconfig`
3. Run `cfgutil install-profile /tmp/focusshift-restrict.mobileconfig`
4. cfgutil communicates with iPhone over WiFi (if on same network) or USB
5. iPhone receives and applies profile immediately
6. Apps disappear from home screen within seconds

**Profile Removal Flow**:
1. Run `cfgutil remove-profile com.focusshift.restrictions`
2. Profile is identified by its unique identifier in the XML
3. iPhone removes restrictions immediately
4. Apps reappear on home screen

**Safety Considerations**:
- Supervision is fully reversible via "Emergency: Remove All Supervision" button
- User can also unsupervise manually via Apple Configurator
- Or by factory resetting the iPhone (Settings > General > Reset > Erase All Content and Settings)
- Supervision does NOT give FocusShift access to user data, messages, photos, etc.
- It only allows installing configuration profiles

### Gotchas & Edge Cases

**Gotcha #1: cfgutil requires iPhone to be paired**
- Before first use, iPhone must "trust" the Mac
- Connect via USB, unlock iPhone, tap "Trust This Computer"
- After initial pairing, cfgutil can work over WiFi (if devices on same network)
- If connection fails, try:
  - Reconnecting USB cable
  - Restarting both devices
  - Running `cfgutil list` to refresh connection

**Gotcha #2: Profile identifiers must be unique**
- Each profile needs a unique identifier (use `com.focusshift.restrictions`)
- If you try to install a profile with same ID as existing one, it will update the existing profile
- This is actually useful - we can update restrictions without removing and reinstalling

**Gotcha #3: Some apps can't be blocked**
- System apps like Phone, Messages, Settings, Camera can't be hidden via restrictions
- These are in the "Essential" category and greyed out in the UI
- Safari can't be hidden but we can filter its content

**Gotcha #4: Supervision and Find My iPhone**
- You must disable Find My iPhone to initially supervise
- But you can (and should!) re-enable it after supervision is complete
- Supervision persists even with Find My enabled

**Gotcha #5: Focus session vs. Mac app quit**
- If user quits the Mac app during focus session, the session should persist
- Store session end time in UserDefaults, not just in memory
- On app relaunch, check if there's an active session and restore it

**Gotcha #6: Scheduled shifts when Mac is asleep**
- If Mac goes to sleep, scheduled timer won't fire
- Two options:
  1. Keep Mac awake using `IOPMAssertionCreateWithName()` (not recommended, drains battery)
  2. Accept that scheduled shifts only work when Mac is awake (simpler, document this limitation)
- Choose option 2 for simplicity

**Gotcha #7: App bundle IDs change**
- Sometimes when apps update, their bundle ID might change (rare)
- If user reports an app isn't blocked, fetch fresh app list and check the bundle ID
- The "Refresh Apps" button solves this

**Gotcha #8: Permissions on macOS**
- cfgutil doesn't require special permissions (unlike some MDM tools)
- But the app might need permission to run shell commands
- Test on a clean Mac to ensure no permission prompts

### Performance Considerations

**Optimization #1: Profile generation should be fast**
- Generate XML string in memory, don't use external XML libraries
- Should complete in <100ms even with hundreds of blocked apps
- Most time is spent in cfgutil, not in Swift code

**Optimization #2: Schedule timer is coarse**
- Checking every 60 seconds is fine (we don't need second-precision)
- If you want more precision, check every 30 seconds
- Don't check every second - wasteful

**Optimization #3: Don't fetch apps repeatedly**
- Fetching installed apps takes 2-3 seconds
- Only fetch when user clicks "Refresh Apps" button
- Cache the app list in UserDefaults between launches

**Optimization #4: Background vs. foreground**
- When app is in background, don't update UI
- Only run schedule timer in background
- Use Combine to publish changes that UI subscribes to

---

## 🚀 Quick Start Commands

### Initial Setup

```bash
# 1. Install Xcode (via Mac App Store - 15GB!)

# 2. Install Apple Configurator (via Mac App Store)

# 3. Verify cfgutil is installed
/Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil version

# 4. Create new Xcode project
# Use Xcode GUI: File > New > Project > macOS > App
# Name: FocusShift
# Interface: SwiftUI
# Language: Swift

# 5. Run the template project
# Click the Play button in Xcode or press Cmd+R
```

### Supervising Your iPhone (ONE-TIME - DO THIS FIRST!)

```bash
# 1. Backup your iPhone via Finder/iTunes first!

# 2. On iPhone: Settings > Face ID & Passcode > Turn OFF Find My iPhone

# 3. Connect iPhone via USB cable to Mac

# 4. Open Apple Configurator app

# 5. Select your iPhone in the list

# 6. Click "Prepare" from the Actions menu at top

# 7. Choose:
#    - Manual Configuration
#    - Do not enroll in MDM  
#    - Supervise devices (check this!)
#    - Create new Supervision Identity (give it a name like "Personal")

# 8. Click "Prepare" and wait 2-5 minutes

# 9. After completion, you'll see "This iPhone is supervised" in Settings > General > About

# 10. Re-enable Find My iPhone (Settings > [Your Name] > Find My)

# You're done! Now FocusShift can control your iPhone.
```

### Running FocusShift

```bash
# Open the Xcode project
open FocusShift.xcodeproj

# Build and run (in Xcode)
# Press Cmd+R or click Play button

# Or build and run from command line
xcodebuild -scheme FocusShift -configuration Debug build
```

---

## 📐 Design System

### Colors

- **Primary** (#5B7FFF): Blue - Used for Unshift button, represents "normal mode"
- **Secondary** (#A78BFA): Purple - Used for Shift button, represents "focus mode"  
- **Success** (#10B981): Green - Connection status, successful operations
- **Warning** (#F59E0B): Orange - Focus session countdown, cautions
- **Danger** (#EF4444): Red - Emergency unsupervise button, errors
- **Background** (#F9FAFB): Light gray - App background
- **Surface** (#FFFFFF): White - Cards and panels
- **Text Primary** (#111827): Almost black - Main text
- **Text Secondary** (#6B7280): Gray - Secondary text, labels

### Typography

- **Headings**: SF Pro Display (system font), Bold, 24pt
- **Subheadings**: SF Pro Display, Semibold, 18pt
- **Body**: SF Pro Text, Regular, 14pt
- **Caption**: SF Pro Text, Regular, 12pt
- **Button Text**: SF Pro Display, Medium, 16pt

### Component Patterns

**Large Action Buttons**: 
- 240px wide, 80px tall
- Bold text with icon
- Pronounced shadow
- Animated press effect
- Used for primary actions (Shift/Unshift)

**Status Indicators**:
- Colored dot (10px diameter) + text
- Pulsing animation when processing
- Lives in top bar of app

**Card Layout**:
- White background
- 12px rounded corners
- Subtle shadow (0 2px 8px rgba(0,0,0,0.1))
- 20px internal padding

**Toggle Switches**:
- System SwiftUI Toggle
- Accent color matches app theme (purple)

**Modal Sheets**:
- Slide up from bottom
- Rounded top corners
- Close button in top-left
- Centered title

---

## ✅ Success Metrics

### User Experience
- **Shift time**: <2 seconds from button click to apps disappearing on iPhone
- **Unshift time**: <2 seconds from button click to apps reappearing
- **Setup time**: <10 minutes from download to first successful shift (assuming iPhone is already supervised)
- **Focus session success rate**: 95%+ of sessions complete without interruption

### Technical
- **App launch time**: <1 second
- **Memory usage**: <50MB when idle
- **Profile generation**: <100ms
- **Schedule check interval**: Every 60 seconds
- **Crash rate**: 0% (handle all errors gracefully)

---

## 🔮 Future Enhancements

### Phase 2 (Post-MVP)

**Analytics Dashboard**:
- Track how many hours per day phone is shifted vs. unshifted
- Show graphs of usage over time
- Celebrate streaks ("7 days of focused evenings!")

**Multiple Devices**:
- Support iPad in addition to iPhone
- Sync shift state across devices
- "Shift all my devices" button

**Emergency Contacts Bypass**:
- During shifted mode, calls/texts from specific contacts (family) still work
- Apps are still hidden, but notifications come through

**App Usage Insights**:
- Show which apps you use most when unshifted
- Suggest apps to add to block list based on usage

**Cloud Sync** (requires backend):
- Sync preferences across Macs
- Control iPhone shift state from any Mac you own

### Nice-to-Haves

**iOS Companion App**:
- View shift status on iPhone
- Request unshift via notification (approval needed on Mac)
- Show remaining focus session time

**Shift from iPhone Shortcuts**:
- Create a Shortcuts action that triggers shift via local API
- Allows Siri control: "Hey Siri, shift my iPhone"

**Whitelist by Time**:
- "Allow Instagram only between 6pm-7pm"
- Temporary unblock for specific apps

**Focus Environments**:
- Predefined profiles: "Work", "Sleep", "Deep Focus", "Weekend"
- Each has different blocked apps and schedules
- Quick switch between environments

---

## 🚨 Emergency Information

### If Something Goes Wrong

**iPhone is stuck in shifted mode and Mac app won't unshift it:**
1. Open Apple Configurator (not FocusShift)
2. Select your iPhone
3. Click "Remove Profile" from Actions menu
4. Select "FocusShift Restrictions"
5. Click Remove

**iPhone is supervised and I want to remove supervision completely:**
1. Open FocusShift Mac app
2. Click "Emergency Options" at bottom
3. Click "Remove All Supervision"
4. Type "REMOVE" to confirm
5. OR: Use Apple Configurator > Select iPhone > Actions > Unsupervise

**I lost access to my Mac and need to unsupervise:**
1. Factory reset your iPhone: Settings > General > Transfer or Reset iPhone > Erase All Content and Settings
2. This removes supervision but also erases everything (so back up first!)

**Mac app won't detect my iPhone:**
1. Reconnect USB cable
2. Unlock iPhone and tap "Trust This Computer" if prompted
3. Run this in Terminal to test:
   ```bash
   /Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil list
   ```
4. If no output, restart both devices and try again

**Focus session won't end:**
1. Open FocusShift
2. Click "Emergency Options"
3. Click "End Focus Session" (requires confirmation)
4. OR: Wait for the timer to expire naturally

### Support Resources

Since this is for personal use:
- Keep this PRD for reference
- Apple Configurator documentation: https://support.apple.com/guide/apple-configurator-mac
- cfgutil command reference: Run `cfgutil help` in Terminal
- If all else fails: Unsupervise and re-supervise from scratch

---

## 📚 Additional Context

### Why Supervision Works

Apple's device supervision is designed for organizations (schools, companies) to manage devices they own. It gives administrators deep control over device capabilities - much deeper than Screen Time or parental controls. When a device is supervised:

- Configuration profiles can't be removed by the user
- Restrictions are enforced at the system level (apps literally don't appear)
- It's not a "soft" lock that can be bypassed by deleting an app
- Even restoring from backup doesn't bypass supervision

This is exactly what we need for a distraction-blocking tool. The supervision framework treats your Mac app as the "administrator" and your iPhone as the "managed device". It's unconventional (usually MDM servers play this role, not desktop apps), but it works perfectly for personal use.

### Learning Resources

**For Swift/SwiftUI beginners**:
- Apple's SwiftUI tutorials: https://developer.apple.com/tutorials/swiftui
- Hacking with Swift: https://www.hackingwithswift.com/100/swiftui (free 100-day course)
- Stanford CS193p on YouTube: Excellent SwiftUI course

**For Shell/Process execution in Swift**:
- Apple docs on Process: https://developer.apple.com/documentation/foundation/process
- Stack Overflow has many examples of running terminal commands from Swift

**For Configuration Profiles**:
- Apple Configuration Profile Reference: https://developer.apple.com/business/documentation/Configuration-Profile-Reference.pdf
- This 300-page PDF documents every possible profile setting

### Feasibility Assessment for a Noob

**Difficulty: Moderate-High (6-7/10)**

Here's the honest assessment:

**What makes this feasible**:
- ✅ SwiftUI is beginner-friendly (declarative, lots of tutorials)
- ✅ No backend needed (everything local)
- ✅ cfgutil does the heavy lifting (you're just calling it)
- ✅ Small scope (it's a simple app conceptually)
- ✅ You only need to build it once for yourself

**What makes this challenging**:
- ❌ macOS development has a learning curve (if you've never used Xcode)
- ❌ Configuration profiles are complex (XML format, cryptic keys)
- ❌ Shell command execution in Swift is a bit tricky
- ❌ Supervision setup is manual and requires understanding Apple's ecosystem
- ❌ Debugging iOS-Mac interaction is harder than pure Mac or iOS apps

**Time Estimate**:
- If you're a complete beginner: **20-30 hours** total
  - 5-6 hours learning Swift/SwiftUI basics
  - 2-3 hours setting up and understanding supervision
  - 12-18 hours building the features (following the phases)
  - 3-5 hours testing and fixing bugs

- If you have some coding experience: **12-18 hours**
  - 2 hours Swift/SwiftUI basics
  - 1-2 hours supervision setup
  - 8-12 hours building
  - 2-3 hours polishing

**My Recommendation**:
This is absolutely buildable for a noob, but don't rush it. Break it into the phases I outlined. Get Phase 1 working (just detecting the iPhone and running cfgutil list) before moving on. Each phase builds on the last.

The hardest parts will be:
1. **Initial supervision** - Follow the instructions carefully, it's a one-time pain
2. **Understanding configuration profiles** - Use the template I provided, don't try to write XML from scratch
3. **Debugging cfgutil errors** - Test commands in Terminal first to make sure they work

The GOOD news:
- Once supervision works, the rest is just UI and logic
- SwiftUI makes UI surprisingly easy
- I've given you detailed specifications for everything
- You can test each piece incrementally

**Can you do it? YES.** 
**Will you learn a ton? ABSOLUTELY.**
**Is it worth it? 100% - you'll have a custom tool that solves a real problem you have.**

Start with Phase 1 and see how it feels. If you can get the app to detect your iPhone and run `cfgutil list`, you're 30% of the way there!
