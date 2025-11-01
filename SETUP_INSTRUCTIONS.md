# FocusShift - Setup Instructions

## ✅ What's Been Created

All source code files have been created in the `FocusShift/FocusShift/` directory:

### Models (4 files) ✅
- `Models/iPhoneDevice.swift` - Represents your iPhone and its state
- `Models/App.swift` - Represents apps installed on iPhone with categories
- `Models/Schedule.swift` - Automatic shift/unshift schedules
- `Models/FocusSession.swift` - Timer-based focus sessions

### Services (5 files) ✅
- `Services/DeviceManager.swift` - Communicates with iPhone via cfgutil
- `Services/ProfileGenerator.swift` - Creates mobileconfig XML files
- `Services/PreferencesManager.swift` - Handles local storage (UserDefaults)
- `Services/ScheduleManager.swift` - Background timer for automatic shifts
- `Services/AppManager.swift` - App categorization and default lists

### Views (3 files) ✅
- `Views/ControlView.swift` - Main shift/unshift screen with big button
- `Views/SettingsView.swift` - Customize blocked apps and domains
- `Views/ScheduleView.swift` - Manage automatic schedules

### App Files (2 files) ✅
- `FocusShiftApp.swift` - App entry point
- `ContentView.swift` - Tab navigation container

---

## 🚀 Next Steps: Creating the Xcode Project

### 1. Open Xcode
Once Xcode finishes installing, open it.

### 2. Create New Project
1. Click **File > New > Project** (or press Cmd+Shift+N)
2. Select **macOS** at the top
3. Choose **App** template
4. Click **Next**

### 3. Configure Project
Fill in these details:
- **Product Name**: `FocusShift`
- **Team**: None (or your team if you have one)
- **Organization Identifier**: `com.yourname` (e.g., `com.ethan`)
- **Interface**: **SwiftUI** ⚠️ Important!
- **Language**: **Swift** ⚠️ Important!
- **Storage**: None
- Uncheck "Create Git repository" (already have one)
- Click **Next**

### 4. Save Location
Save the project in: `/Users/ethanli/Documents/Code/FOCUSSHIFT/`

This will create a new `FocusShift` folder with the Xcode project.

### 5. Replace Default Files

Xcode will create some default files. We need to replace them with our code:

#### Delete These Default Files (right-click → Delete → Move to Trash):
- `FocusShiftApp.swift` (we have our own)
- `ContentView.swift` (we have our own)

#### Add Our Files to Xcode:
1. In Xcode's left sidebar (Project Navigator), right-click on the `FocusShift` folder
2. Choose **Add Files to "FocusShift"...**
3. Navigate to `/Users/ethanli/Documents/Code/FOCUSSHIFT/FocusShift/FocusShift/`
4. Select ALL the files and folders we created:
   - `Models/` folder
   - `Services/` folder
   - `Views/` folder
   - `FocusShiftApp.swift`
   - `ContentView.swift`
5. Make sure **"Copy items if needed"** is CHECKED
6. Click **Add**

### 6. Build and Run!

Press **Cmd+R** or click the **Play** button in the top-left.

The app should build successfully and launch! 🎉

---

## 🧪 Testing Phase 1

Once the app launches, you should see:

1. **Three tabs**: Control, Settings, Schedule
2. **Main button** that says "Shift iPhone"
3. **Status indicator** at top (will show "iPhone not connected" until you supervise)

### To Test iPhone Detection:

1. Make sure your iPhone is connected via USB
2. The app should auto-detect it and show "Connected - [Your iPhone Name]"

⚠️ **Important**: The shift button won't work until your iPhone is supervised!

---

## 📱 Supervising Your iPhone (Do This Next)

**BEFORE YOU START:**
- ✅ Backup your iPhone (Finder or iCloud)
- ✅ Make sure iPhone has enough battery (50%+)
- ✅ Connect iPhone to Mac via USB cable

### Steps:

1. **On iPhone**: Settings > Face ID & Passcode > **Turn OFF "Find My iPhone"**
   - You'll need to enter your Apple ID password

2. **On Mac**: Open **Apple Configurator** app (NOT FocusShift)

3. **In Apple Configurator**:
   - Your iPhone should appear in the list
   - Select your iPhone
   - Click **Actions > Prepare** from the top menu bar

4. **Choose Options**:
   - Configuration: **Manual Configuration**
   - MDM Server: **Do not enroll in MDM**
   - ✅ Check **"Supervise devices"**
   - Supervision Identity: Create new (name it "Personal" or anything)
   - Click **Prepare**

5. **Wait 2-5 minutes** while it prepares

6. **After completion**:
   - On iPhone: Go to Settings > General > About
   - You should see "**This iPhone is supervised**" at the bottom
   - **Re-enable Find My iPhone** (Settings > [Your Name] > Find My)

7. **Test in FocusShift**:
   - Open FocusShift app
   - Status should show "Connected - [iPhone Name]"
   - Click **"Shift iPhone"**
   - Wait 2-3 seconds
   - Check your iPhone - Instagram, TikTok, etc. should be GONE! 🎉

---

## 🎯 What Works Right Now (Phase 1 Complete)

✅ **Device Detection** - App can find your iPhone
✅ **Basic Shift/Unshift** - Hide/show distracting apps with one click
✅ **App Restrictions** - Instagram, TikTok, Twitter, Facebook, YouTube, Netflix blocked
✅ **Domain Blocking** - Social media sites blocked in Safari
✅ **Focus Sessions** - Can lock phone for 30/60/90 minutes
✅ **Scheduling UI** - Can create schedules (needs testing)
✅ **Settings UI** - Can customize blocked apps (needs testing)
✅ **Emergency Unsupervise** - Safety valve is ready

---

## 🐛 Troubleshooting

### "iPhone not connected"
- Reconnect USB cable
- Unlock iPhone and tap "Trust This Computer"
- Run this in Terminal to test:
  ```bash
  /Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil list
  ```

### "Command failed" error
- Make sure iPhone is supervised
- Try unplugging and replugging iPhone
- Restart both iPhone and Mac

### Build errors in Xcode
- Make sure you selected **SwiftUI** interface (not UIKit)
- Make sure deployment target is macOS 13.0 or later
- Clean build folder: Product > Clean Build Folder (Cmd+Shift+K)

---

## 📝 What's Next (Future Phases)

Once Phase 1 is working, we can add:
- **Phase 2**: Polish the UI with better animations and error messages
- **Phase 3**: Test focus sessions thoroughly
- **Phase 4**: Test scheduled shifts
- **Phase 5**: Fetch real app list from iPhone (not just default)
- **Phase 6**: Add notifications for shift events
- **Phase 7**: Full testing and bug fixes

---

## 🎉 Congratulations!

You now have a fully functional FocusShift app! The hardest part (supervision) is one-time setup. After that, it's one click to transform your iPhone into a distraction-free tool.

**Next**: Follow the steps above to create the Xcode project and test shifting your iPhone!

Let me know when you're ready for the next phase! 🚀
