# Initial Prompt for Claude Code

Copy this prompt and paste it into Claude Code to start building FocusShift.

---

Hi Claude! I need you to help me build **FocusShift** - a macOS app that blocks distracting apps on my iPhone. I'm a **complete coding noob**, so please **explain what you're doing in simple terms, show me commands to run, and ask questions if anything is unclear**.

## What We're Building

FocusShift is a personal productivity tool that transforms my iPhone between "normal mode" (all apps available) and "focus mode" (only essential apps available) at the push of a button. It uses Apple's device supervision technology to make restrictions truly unbreakable - when my phone is "shifted," social media apps literally disappear and can't be accessed.

The Mac app communicates with my supervised iPhone using Apple Configurator's command-line tool (cfgutil) to install and remove configuration profiles. When shifted, Instagram, Twitter, TikTok, YouTube, etc. are hidden. When unshifted, everything comes back. It's like having a dumbphone and smartphone in one device.

This is for personal use - no backend, no subscriptions, just a local Mac app that does one thing really well.

**Core Features**:
1. **One-Click Shift/Unshift** - Big button that instantly hides/shows distracting apps on iPhone
2. **Focus Sessions** - Lock in shifted mode for 30/60/90 minutes (can't unshift until timer expires)
3. **Automatic Scheduling** - Auto-shift at specified times (e.g., every night at 9pm)
4. **App Management** - Customize which apps get blocked (whitelist/blacklist)
5. **Safari Content Filtering** - Block social media websites too (instagram.com, twitter.com, etc.)
6. **Emergency Unsupervise** - Safety button to completely remove all restrictions if needed

## Product Spec

I have a complete PRD in `PRD.md` - **please read it carefully**. It includes:
- Full page layouts and user flows
- Configuration profile XML templates
- All the cfgutil commands you'll need
- Detailed implementation phases
- Models and data structures
- Troubleshooting guides

## Tech Stack

- **Frontend**: Swift + SwiftUI (native Mac app)
- **State Management**: Combine Framework (reactive UI updates)
- **System Integration**: cfgutil (Apple Configurator command-line tool)
- **Device Control**: Configuration Profiles (mobileconfig XML files)
- **Local Storage**: UserDefaults (no database needed)
- **Key Dependencies**: None! All system frameworks

## What I Need From You

### Phase 1: Initial Setup (Start Here!)

Please help me:
1. Create the basic Xcode project structure
2. Set up the Models (iPhoneDevice, App, Schedule, FocusSession)
3. Create the Services folder with stubs for DeviceManager, ProfileGenerator, etc.
4. Build basic ContentView with three tabs (Control, Settings, Schedule)
5. Create placeholder views for each tab
6. Add a test button that runs `cfgutil list` and displays the output

**Note**: I've already supervised my iPhone using Apple Configurator, so cfgutil should work. We need to test that first!

### Phase 2: Core Shift/Unshift

Build the main functionality:
1. Implement ProfileGenerator.createRestrictionsProfile() - generates mobileconfig XML
2. Implement DeviceManager.shiftDevice() - writes profile to /tmp and runs `cfgutil install-profile`
3. Implement DeviceManager.unshiftDevice() - runs `cfgutil remove-profile`
4. Build ControlView with the big Shift/Unshift button
5. Test on my real iPhone - apps should disappear when shifted!

### Phase 3: Focus Sessions

Add timer-based locking:
1. Create FocusSession model
2. Add PreferencesManager to save/load sessions from UserDefaults
3. Update DeviceManager to handle optional duration parameter
4. Build FocusSessionPicker component (4 pills: No Timer, 30min, 60min, 90min)
5. Add countdown display that disables Unshift button
6. Test that session persists across app restarts

### Phase 4: Scheduling

Automatic shift/unshift at specified times:
1. Create Schedule model with time and day properties
2. Implement ScheduleManager with UserDefaults storage
3. Add background Timer (every 60 seconds) that checks schedules
4. Build ScheduleView to list and manage schedules
5. Build Add Schedule modal with time picker and day selector
6. Test that scheduled shifts happen automatically

### Phase 5: App Management

Customize which apps get blocked:
1. Implement DeviceManager.fetchInstalledApps() - runs `cfgutil list-apps`
2. Create DefaultApps.json with categorized app lists (social, entertainment, etc.)
3. Build SettingsView with category sidebar and app list
4. Add toggle switches for each app (Block when shifted / Allow when shifted)
5. Add Blocked Domains section for Safari filtering
6. Update ProfileGenerator to use user's custom app list

### Phase 6: Polish & Safety

Add emergency features and polish:
1. Build EmergencyPanel component with "Remove All Supervision" button
2. Implement DeviceManager.removeSupervision() - runs `cfgutil remove-supervision`
3. Add macOS notifications for shift events
4. Add loading states and animations to UI
5. Implement error handling for all cfgutil commands
6. Apply design system colors (see PRD for color palette)

### Phase 7: Testing

Ensure everything works:
1. Test all features (shift, unshift, sessions, schedules, customization)
2. Test edge cases (iPhone disconnects, Mac goes to sleep, etc.)
3. Add logging with os_log for debugging
4. Fix any bugs we find

## Important Notes

- **cfgutil path**: `/Applications/Apple Configurator.app/Contents/MacOS/cfgutil`
- **Profile identifier**: Always use `com.focusshift.restrictions` for consistency
- **Safety first**: Emergency unsupervise should always work, even during focus sessions
- **Design aesthetic**: Clean, minimal, modern macOS app (think Apple's design language)
- **Error messages**: User-friendly, with troubleshooting tips (see PRD for examples)

## How to Help Me

Since I'm a complete beginner:

1. **Explain before doing** - Tell me what you're about to create and why
2. **Show commands** - If I need to run anything in Terminal, show me the exact command
3. **Simple language** - Avoid jargon when possible, or explain terms when you use them
4. **Ask questions** - If the PRD is unclear about something, ask me before proceeding
5. **Test as we go** - Let's make sure each piece works before moving to the next
6. **One file at a time** - Don't create too many files at once, I want to understand each one

## Let's Start!

Can you please:
1. **Read PRD.md** to understand the full specification
2. **Explain the overall architecture** to me in simple terms (how the pieces fit together)
3. **Start with Phase 1**: Create the Xcode project structure
4. **Show me** exactly what to do in Xcode and what commands to run

I'm excited to build this! 🚀 Let me know if you need any clarification on anything in the PRD.

---

## Quick Reference

**Default blocked apps** (bundle IDs):
- com.burbn.instagram (Instagram)
- com.atebits.Tweetie2 (Twitter/X)
- com.zhiliaoapp.musically (TikTok)
- com.facebook.Facebook (Facebook)
- com.google.ios.youtube (YouTube)
- com.netflix.Netflix (Netflix)

**Default blocked domains**:
- instagram.com
- twitter.com
- x.com
- tiktok.com
- facebook.com
- youtube.com
- netflix.com

**Essential apps** (can't be blocked):
- com.apple.mobilephone (Phone)
- com.apple.MobileSMS (Messages)
- com.apple.Preferences (Settings)
- com.apple.camera (Camera)

**Test commands**:
```bash
# Check if cfgutil works
/Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil version

# List connected devices
/Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil list

# List installed apps (after device connected)
/Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil list-apps
```
