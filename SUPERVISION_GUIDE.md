# iPhone Supervision Guide for FocusShift

**Complete step-by-step guide to supervising your iPhone**

⏱️ **Time Required**: 10-15 minutes
⚠️ **ONE-TIME SETUP**: You only need to do this once!

---

## 🎯 What is Supervision?

**Supervision** is Apple's enterprise feature that gives administrators (you!) deep control over iOS devices. It's normally used by schools and companies to manage devices.

**For FocusShift**: Supervision allows the Mac app to install configuration profiles that actually HIDE apps from the home screen. This is much stronger than Screen Time or parental controls - apps literally disappear.

**Safety**: You can remove supervision anytime (via the Emergency button in FocusShift, or by factory resetting).

---

## 📋 Before You Start

### Requirements:
- ✅ Mac with Apple Configurator installed
- ✅ iPhone with iOS 13 or later
- ✅ USB cable (Lightning or USB-C depending on iPhone model)
- ✅ iPhone passcode (you'll need to enter it)
- ✅ Apple ID password (to disable Find My)

### Important Notes:
- ⚠️ **BACKUP YOUR IPHONE FIRST** (via iCloud or Finder)
- ⚠️ You must temporarily disable Find My iPhone
- ⚠️ iPhone will NOT be erased (if already supervised, will be; if not, won't be)
- ⚠️ You can re-enable Find My after supervision is complete
- ⚠️ Your data, apps, and settings will be preserved

---

## 🔐 Step 1: Backup Your iPhone

**via iCloud**:
1. iPhone → Settings → [Your Name] → iCloud → iCloud Backup
2. Tap "Back Up Now"
3. Wait for backup to complete

**OR via Finder** (recommended - faster):
1. Connect iPhone to Mac via USB
2. Open Finder
3. Click iPhone in sidebar
4. Click "Back Up Now"
5. Wait for backup to complete

✅ **Verify backup completed** before continuing!

---

## 🔓 Step 2: Disable Find My iPhone

**On iPhone**:
1. Settings → [Your Name] (at top)
2. Find My
3. Find My iPhone
4. Toggle **OFF**
5. Enter your **Apple ID password**
6. Tap "Turn Off"

✅ **Verify "Find My iPhone" is OFF** before continuing!

---

## 🔌 Step 3: Connect iPhone to Mac

1. Connect iPhone to Mac with USB cable
2. Unlock iPhone with passcode
3. On iPhone, you'll see **"Trust This Computer?"** alert
4. Tap **"Trust"**
5. Enter iPhone passcode
6. iPhone should now show "Trusted" on Mac

✅ **Wait for iPhone to appear** in Finder sidebar

---

## 🛠️ Step 4: Open Apple Configurator

1. Open **Apple Configurator** app (NOT FocusShift)
   - Spotlight: Cmd+Space, type "Apple Configurator"
   - Or: Applications → Apple Configurator
2. Your iPhone should appear in the main window
3. You'll see: Icon + iPhone name + model

✅ **If iPhone doesn't appear**:
- Reconnect USB cable
- Make sure iPhone is unlocked
- Check you tapped "Trust This Computer"

---

## ⚙️ Step 5: Prepare (Supervise) the iPhone

This is the critical step!

1. In Apple Configurator, **click your iPhone** (once) to select it
2. From the top menu bar, click **Actions → Prepare...**
3. A dialog appears: "Prepare Devices"

### Configuration Options (IMPORTANT - Get these right!):

**Screen 1: Configuration**
- Select: **Manual Configuration**
- Click **Next**

**Screen 2: Server and Organization**
- MDM Server: **Do not enroll in MDM**
- Organization: Enter any name (e.g., "Personal" or your name)
- Click **Next**

**Screen 3: Supervision**
- ✅ **CHECK "Supervise devices"** ⚠️ CRITICAL!
- Supervision Identity: **Create a new supervision identity**
  - Name: "Personal" (or anything you want)
  - Certificate: Leave default
- Click **Prepare**

**Screen 4: Confirmation**
- Review settings
- Click **Prepare** to confirm

---

## ⏳ Step 6: Wait for Supervision

**What happens**:
1. Apple Configurator prepares supervision profile
2. Sends it to iPhone
3. iPhone applies supervision settings
4. Progress bar on Mac and iPhone

**Time**: 2-5 minutes typically

**What you'll see**:
- Progress bar in Apple Configurator
- iPhone screen may show Apple logo or progress bar
- iPhone will NOT erase (unless it was previously supervised by different identity)

⚠️ **DO NOT DISCONNECT** iPhone during this process!

✅ **Wait for "Preparation Complete"** message

---

## ✅ Step 7: Verify Supervision

**On iPhone**:
1. Settings → General → About
2. Scroll to bottom
3. You should see: **"This iPhone is supervised"**
4. Below it: "Managed by [Your Mac Name]"

✅ **If you see this text, supervision succeeded!** 🎉

---

## 🔐 Step 8: Re-enable Find My iPhone

**IMPORTANT**: You can and should re-enable Find My now!

**On iPhone**:
1. Settings → [Your Name] → Find My
2. Find My iPhone
3. Toggle **ON**
4. Enter Apple ID password if prompted

✅ **Supervision will remain** even with Find My enabled!

---

## 🧪 Step 9: Test with FocusShift

Now let's test that FocusShift can control your iPhone!

1. **Open FocusShift** Mac app
2. Connect iPhone via USB (if not still connected)
3. Check status indicator at top:
   - Should show: **"Connected - [iPhone Name]"** ✅
4. Click the big **"Shift iPhone"** button
5. Wait 2-3 seconds...
6. **Pick up your iPhone**
7. Check home screen: Instagram, TikTok, Twitter should be **GONE!** 🎉

**If apps disappeared**: ✅ **SUCCESS! Supervision works!**

**To bring apps back**:
1. In FocusShift, click **"Unshift iPhone"**
2. Apps should reappear in ~2 seconds

---

## 🚨 Troubleshooting

### Problem: iPhone not appearing in Apple Configurator
**Fix**:
- Reconnect USB cable (try different cable/port)
- Unlock iPhone
- Re-trust computer (Settings → General → Reset → Reset Location & Privacy, then reconnect)
- Restart both iPhone and Mac

---

### Problem: "This device is supervised by another organization"
**Meaning**: iPhone was previously supervised

**Fix**:
- You need to remove old supervision first
- Apple Configurator → Select iPhone → Actions → Unsupervise
- Then start supervision process again
- ⚠️ This WILL erase the iPhone! Restore from backup after.

---

### Problem: Preparation fails with error
**Common errors**:
- "Unable to prepare device" → Check USB connection, retry
- "Passcode required" → Unlock iPhone, enter passcode
- "Find My must be disabled" → Go back to Step 2

**Nuclear option**:
- Disconnect iPhone
- Restart Mac
- Restart iPhone
- Start from Step 3 again

---

### Problem: FocusShift shows "iPhone not connected" after supervision
**Fix**:
1. Quit and restart FocusShift app
2. Reconnect iPhone via USB
3. Check with Terminal:
   ```bash
   /Applications/Apple\ Configurator.app/Contents/MacOS/cfgutil list
   ```
4. If cfgutil sees iPhone, FocusShift should too

---

### Problem: Shift button doesn't work
**Possible causes**:
1. **iPhone not supervised** → Check Settings → About for "supervised" text
2. **iPhone not connected** → Reconnect USB
3. **cfgutil error** → Check Terminal command above
4. **App permissions** → Check Signing & Capabilities in Xcode

---

## 🔄 How to Remove Supervision Later

**Option 1: FocusShift Emergency Button** (Easiest)
1. Open FocusShift
2. Click "Emergency Options" at bottom
3. Click "Remove All Supervision"
4. Type "REMOVE" to confirm
5. Done! iPhone is no longer supervised

**Option 2: Apple Configurator**
1. Open Apple Configurator
2. Connect iPhone
3. Select iPhone
4. Actions → Unsupervise
5. Confirm

**Option 3: Factory Reset** (Nuclear option)
1. iPhone → Settings → General → Transfer or Reset iPhone
2. Erase All Content and Settings
3. This removes supervision but also ERASES EVERYTHING
4. Restore from backup after

---

## 🎯 What Supervision Allows FocusShift to Do

**Allowed**:
- ✅ Install configuration profiles (app restrictions)
- ✅ Hide apps from home screen
- ✅ Block websites in Safari
- ✅ Remove profiles/restrictions remotely

**NOT Allowed** (FocusShift does NOT have access to):
- ❌ Your messages or emails
- ❌ Your photos or files
- ❌ Your location
- ❌ Your passwords
- ❌ Any personal data

Supervision only allows profile management - NOT data access!

---

## 📱 Supported iPhone Models

**All iPhones** with iOS 13+ are supported:
- iPhone 6s and later
- iPhone SE (all generations)

**Best results**: iOS 15+ (better profile support)

---

## 🎉 Success Checklist

You've successfully supervised your iPhone when:
- ✅ Settings → About shows "This iPhone is supervised"
- ✅ FocusShift shows "Connected - [iPhone Name]"
- ✅ Clicking "Shift" makes apps disappear
- ✅ Clicking "Unshift" brings apps back
- ✅ Find My iPhone is re-enabled

**Congrats! You're ready to use FocusShift!** 🚀

---

## 💡 Pro Tips

1. **Backup regularly** - Even though supervision is safe, backups are always good
2. **Keep Find My enabled** - Supervision works fine with it
3. **Test in controlled environment first** - Shift/unshift a few times to get comfortable
4. **Use Focus Sessions** - Try a 30-min session to test the timer lock
5. **Set up schedules** - Auto-shift at bedtime is a game-changer

---

## 📞 Need Help?

If you're stuck at any step:
1. Take a screenshot of the error
2. Note which step you're on
3. Tell Claude: "Supervision failed at step X with: [error]"
4. I'll help you troubleshoot!

**Remember**: Millions of schools and companies use supervision - it's a mature, reliable technology. If something goes wrong, we can fix it! 💪
