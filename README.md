# FocusShift

Transform your iPhone into a distraction-free tool at the push of a button.

---

## 🚀 Quick Setup

### 1. Install Prerequisites

1. **Install Xcode** (via Mac App Store - 15GB)
2. **Install Apple Configurator** (via Mac App Store)
3. **Verify cfgutil**:
   ```bash
   /Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil version
   ```

### 2. Supervise Your iPhone (One-Time Setup)

⚠️ **IMPORTANT: Backup your iPhone first!**

1. On iPhone: Settings > Face ID & Passcode > **Turn OFF "Find My iPhone"**
2. Connect iPhone to Mac via USB cable
3. Open **Apple Configurator** app (not FocusShift)
4. Select your iPhone
5. Click **"Prepare"** from Actions menu
6. Choose:
   - Manual Configuration
   - Do not enroll in MDM
   - ✅ **Supervise devices**
   - Create new Supervision Identity (name it "Personal")
7. Click **Prepare** and wait 2-5 minutes
8. After setup, re-enable Find My iPhone
9. Verify: Settings > General > About should show "This iPhone is supervised"

### 3. Create Xcode Project

```bash
# Open Xcode
# File > New > Project
# Choose: macOS > App
# Name: FocusShift
# Interface: SwiftUI
# Language: Swift
```

### 4. Run the App

```bash
# Press Cmd+R in Xcode or click the Play button
```

---

## 🛠️ Tech Stack

- **Swift + SwiftUI** - Native Mac app with modern declarative UI
- **Combine Framework** - Reactive state management and async operations
- **cfgutil** - Apple Configurator command-line tool for device control
- **Configuration Profiles** - XML-based restrictions (mobileconfig format)
- **UserDefaults** - Local storage for preferences and schedules

---

## 📁 Project Structure

```
FocusShift/
├── FocusShift/
│   ├── FocusShiftApp.swift             # App entry point
│   ├── ContentView.swift               # Main tab container
│   ├── Views/
│   │   ├── ControlView.swift           # Main shift/unshift screen
│   │   ├── SettingsView.swift          # App management
│   │   ├── ScheduleView.swift          # Scheduling
│   │   └── Components/                 # Reusable UI components
│   ├── Models/
│   │   ├── iPhoneDevice.swift          # Device state
│   │   ├── App.swift                   # Installed apps
│   │   ├── Schedule.swift              # Schedule rules
│   │   └── FocusSession.swift          # Focus session state
│   ├── Services/
│   │   ├── DeviceManager.swift         # cfgutil wrapper
│   │   ├── ProfileGenerator.swift      # Creates mobileconfig files
│   │   ├── ScheduleManager.swift       # Handles scheduled shifts
│   │   └── PreferencesManager.swift    # UserDefaults wrapper
│   └── Resources/
│       ├── Assets.xcassets/            # Colors and icons
│       └── DefaultApps.json            # Default app categories
└── FocusShift.xcodeproj
```

---

## 🏗️ Development Order

### Phase 1: Foundation (2-3 hours)
- Set up Xcode project
- Supervise iPhone (one-time)
- Create basic UI with tabs
- Test cfgutil communication
- Verify iPhone detection

### Phase 2: Core Shift/Unshift (3-4 hours)
- Implement profile generation
- Build shift/unshift logic in DeviceManager
- Create main control view with big button
- Test on real iPhone

### Phase 3: Focus Sessions (2-3 hours)
- Add timer-based focus sessions
- Build session picker UI
- Implement countdown and session lock
- Add manual override

### Phase 4: Scheduling (3-4 hours)
- Create schedule model and manager
- Build schedule view with add/edit
- Implement background timer for auto-shifts
- Test scheduled shifts

### Phase 5: App Management (4-5 hours)
- Fetch installed apps from iPhone
- Build settings view with categories
- Add whitelist/blacklist toggles
- Implement blocked domains management
- Add "Refresh Apps" functionality

### Phase 6: Polish & Safety (3-4 hours)
- Build emergency unsupervise feature
- Add notifications for shift events
- Polish UI with colors and animations
- Implement error handling
- Add loading states

### Phase 7: Testing (2-3 hours)
- Test all features thoroughly
- Test edge cases
- Add logging for debugging
- Create user documentation

**Total: 20-30 hours for a complete beginner**

---

## ⚡ Key Features

1. **One-Click Shift/Unshift** - Instantly hide distracting apps
2. **Smart App Filtering** - Default block list of social media/entertainment
3. **Custom Whitelist/Blacklist** - Customize which apps get blocked
4. **Safari Content Filtering** - Block social media websites too
5. **Focus Sessions** - Lock shifted mode for 30/60/90 minutes
6. **Automatic Scheduling** - Auto-shift at specified times
7. **Emergency Unsupervise** - Safety valve to remove all restrictions

---

## 🚨 Emergency Commands

### If iPhone is stuck shifted:
```bash
# Option 1: Use Apple Configurator GUI
# Open Apple Configurator > Select iPhone > Remove Profile

# Option 2: Use command line
/Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil remove-profile com.focusshift.restrictions
```

### To completely remove supervision:
```bash
# Option 1: Use FocusShift's Emergency button (recommended)
# Open FocusShift > Emergency Options > Remove All Supervision

# Option 2: Use Apple Configurator
# Open Apple Configurator > Select iPhone > Actions > Unsupervise

# Option 3: Command line
/Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil remove-supervision

# Option 4: Factory reset iPhone (erases everything!)
# Settings > General > Transfer or Reset iPhone > Erase All Content and Settings
```

---

## 📖 Documentation

See `PRD.md` for complete product specification including:
- Detailed feature descriptions
- Technical architecture
- Implementation guides
- Troubleshooting tips
- Learning resources

---

## 🎓 Learning Resources

**Swift/SwiftUI for Beginners:**
- Apple's SwiftUI Tutorials: https://developer.apple.com/tutorials/swiftui
- Hacking with Swift: https://www.hackingwithswift.com/100/swiftui
- Stanford CS193p: Search on YouTube

**Apple Configurator:**
- Official Guide: https://support.apple.com/guide/apple-configurator-mac
- Configuration Profile Reference: https://developer.apple.com/business/documentation/Configuration-Profile-Reference.pdf

---

## 💡 Tips for Success

1. **Start with Phase 1** - Don't skip ahead. Get iPhone detection working first.
2. **Test in Terminal** - Before writing Swift code, test cfgutil commands in Terminal.
3. **One feature at a time** - Build incrementally, test after each addition.
4. **Keep it simple** - Don't over-engineer. The spec gives you everything you need.
5. **Use the PRD** - Reference it constantly. It has all the details.

---

## 🤔 Is This Feasible for a Noob?

**YES!** Here's why:

✅ **SwiftUI is beginner-friendly** - Declarative syntax, lots of tutorials  
✅ **No backend required** - Everything runs locally  
✅ **cfgutil does the hard work** - You're just calling it  
✅ **Small scope** - Simple app, clear requirements  
✅ **Detailed specification** - Step-by-step guide provided  

**Challenges:**
- macOS development learning curve (manageable with tutorials)
- Configuration profiles are complex (templates provided)
- Debugging iOS-Mac interaction (test incrementally)

**Time estimate:** 20-30 hours total for a complete beginner

**The hardest part?** Initial supervision setup. Follow instructions carefully!

**The good news?** Once supervision works, the rest is just UI and logic.

---

## 🎯 Success = Phase 1 Working

If you can build Phase 1 and see your iPhone detected in the app, you're 30% done. Everything else builds on that foundation.

**You can do this.** 💪
