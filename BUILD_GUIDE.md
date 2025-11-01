# FocusShift - Build & Troubleshooting Guide

**Quick Reference**: Common build issues and how to fix them

---

## 🏗️ First Build Checklist

### Before You Build:
- [ ] Xcode is fully installed and updated
- [ ] Project is open in Xcode
- [ ] All files show in Project Navigator (no red names)
- [ ] "FocusShift" scheme is selected in top toolbar
- [ ] "My Mac" is selected as build destination

### To Build:
**Press Cmd+B** or click the ▶️ Play button

---

## 🐛 Common Build Errors & Fixes

### Error 1: "Cannot find type 'X' in scope"
**What it means**: Xcode can't find a class/struct definition

**Fix**:
1. Check that the file containing that type is added to the target
2. In Project Navigator, click the file
3. In right panel (File Inspector), check "FocusShift" under "Target Membership"
4. Clean build folder: Product → Clean Build Folder (Cmd+Shift+K)
5. Rebuild: Cmd+B

---

### Error 2: "No such module 'X'"
**What it means**: Missing import or framework

**Fix**:
1. Check if you're importing the right modules
2. Our code only uses system frameworks:
   - `import Foundation`
   - `import SwiftUI`
   - `import Combine`
3. No third-party dependencies needed!

---

### Error 3: "Ambiguous use of 'App'"
**What it means**: Our `App.swift` model conflicts with SwiftUI's `App` protocol

**Fix** (if this happens):
We might need to rename our `App` model to `BlockedApp` or `ManagedApp`

---

### Error 4: "'await' in a function that does not support concurrency"
**What it means**: Swift concurrency issue

**Fix**:
1. Click on project (blue icon at top of navigator)
2. Select "FocusShift" target
3. Build Settings tab
4. Search for "Swift Language Version"
5. Ensure it's set to "Swift 5" or higher

---

### Error 5: Signing errors
**What it means**: App needs to be signed to run

**Fix**:
1. Click project (blue icon)
2. Select "FocusShift" target
3. "Signing & Capabilities" tab
4. Under "Team", select your Apple ID or "Sign to Run Locally"
5. If you don't have a team, you can use automatic signing for local development

---

### Error 6: "Sandbox" or "Entitlements" errors
**What it means**: App permissions need configuration

**Fix**:
1. Go to "Signing & Capabilities" tab
2. Ensure "App Sandbox" is present
3. Check these capabilities:
   - ✅ Outgoing Connections (Client)
   - ✅ User Selected File (Read/Write)

---

## 🔧 Nuclear Option: Clean Everything

If weird errors persist:

1. **Clean Build Folder**: Product → Clean Build Folder (Cmd+Shift+K)
2. **Delete Derived Data**:
   - Xcode → Settings → Locations tab
   - Click arrow next to Derived Data path
   - Delete the "FocusShift-xxxxx" folder
3. **Quit and Restart Xcode**
4. **Rebuild**: Cmd+B

---

## ✅ Successful Build Signs

When build succeeds, you'll see:
- ✅ "Build Succeeded" notification
- ✅ Green checkmark in top toolbar
- ✅ No red errors in Issue Navigator
- ✅ App launches (might see empty window at first)

---

## 🚀 After Successful Build

Once it compiles, you can run it!

**To Run**:
1. Press Cmd+R or click Play button (▶️)
2. App should launch in a new window
3. You should see three tabs: Control, Settings, Schedule
4. Status will show "iPhone not connected" (expected)

---

## 📱 Next: Test iPhone Detection

Once the app runs:

### With iPhone Connected via USB:
1. Connect iPhone with USB cable
2. Unlock iPhone
3. Tap "Trust This Computer" if prompted
4. In FocusShift app, status should update to "Connected - [iPhone Name]"

### If iPhone Doesn't Appear:
1. Check USB cable is connected
2. Try a different USB port
3. Run this in Terminal to test:
   ```bash
   /Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil list
   ```
4. If you see your iPhone's UDID, cfgutil works (app should detect it too)

---

## 🎯 Expected First Run Behavior

**What WILL work**:
- ✅ App launches
- ✅ UI appears (3 tabs, buttons, etc.)
- ✅ iPhone detection (if connected)
- ✅ Settings and Schedule UIs

**What WON'T work yet**:
- ❌ Shift button (iPhone must be supervised first)
- ❌ App list in Settings (need to fetch from iPhone)
- ❌ Schedules triggering (need background permissions)

This is NORMAL! We need to supervise the iPhone first.

---

## 📞 Getting Help

**If you're stuck:**
1. Take a screenshot of the error
2. Copy the full error message
3. Tell Claude: "Build failed with: [error message]"
4. I'll help you fix it!

**Common questions:**
- "Red files in navigator?" → Files not added to target
- "App won't launch?" → Signing issue
- "Buttons don't work?" → Expected, need supervised iPhone
- "Weird UI?" → SwiftUI preview issue, run on Mac instead

---

## 🎉 Success Criteria for Phase 1

You've completed Phase 1 when:
- ✅ Project builds without errors (Cmd+B succeeds)
- ✅ App launches and shows UI (Cmd+R works)
- ✅ Three tabs are visible and clickable
- ✅ Main shift button is visible (even if disabled)
- ✅ No crashes or freezes

**Then**: Move to iPhone Supervision → First Shift Test!

---

## 🔄 Quick Reference Commands

| Action | Shortcut | Menu |
|--------|----------|------|
| Build | Cmd+B | Product → Build |
| Run | Cmd+R | Product → Run |
| Clean | Cmd+Shift+K | Product → Clean Build Folder |
| Stop | Cmd+. | Product → Stop |
| Show Issues | Cmd+5 | View → Navigators → Issue Navigator |

---

## 💡 Pro Tips

1. **Use Issue Navigator** (Cmd+5) to see all build errors in one place
2. **Click errors** to jump to the problematic line
3. **Read error messages carefully** - Swift errors are usually clear
4. **Build incrementally** - Fix one error at a time, rebuild
5. **Don't panic** - Every app has build issues the first time!

---

**Remember**: The code is solid. Most issues are just Xcode configuration. We'll get through them together! 💪
