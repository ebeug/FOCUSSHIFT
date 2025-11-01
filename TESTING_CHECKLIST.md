# FocusShift - Testing Checklist

**Comprehensive testing guide for all features**

Use this checklist to systematically test FocusShift after each phase.

---

## 🏗️ Phase 1: Build & Launch Tests

### ✅ Build Tests
- [ ] Project builds without errors (Cmd+B)
- [ ] No warnings in build log
- [ ] All source files compile successfully
- [ ] Assets load correctly

### ✅ Launch Tests
- [ ] App launches without crashing (Cmd+R)
- [ ] Main window appears
- [ ] Window has correct size (700x500 minimum)
- [ ] All UI elements are visible

### ✅ UI Structure Tests
- [ ] Three tabs are visible (Control, Settings, Schedule)
- [ ] Can click and switch between tabs
- [ ] Each tab shows its content
- [ ] Emergency panel visible at bottom
- [ ] Emergency panel can expand/collapse

---

## 📱 Phase 2: iPhone Connection Tests

### ✅ Device Detection (iPhone via USB)
- [ ] Connect iPhone with USB cable
- [ ] Status shows "Searching for iPhone..."
- [ ] Status updates to "Connected - [iPhone Name]"
- [ ] Green dot appears in status indicator
- [ ] iPhone name displays correctly

### ✅ Connection Edge Cases
- [ ] Disconnect iPhone → status shows "Not Connected"
- [ ] Reconnect iPhone → status updates automatically
- [ ] Multiple reconnects work reliably
- [ ] App doesn't crash when iPhone disconnects during operation

### ✅ Unsupervised iPhone Behavior
- [ ] Status shows "Connected" even if not supervised
- [ ] Shift button is enabled (will fail if clicked, but should be clickable)
- [ ] Error message shows when trying to shift unsupervised iPhone

---

## 🔄 Phase 3: Shift/Unshift Tests

**Prerequisites**: iPhone must be supervised (see SUPERVISION_GUIDE.md)

### ✅ Basic Shift Test
- [ ] Click "Shift iPhone" button
- [ ] Button shows loading state ("Shifting...")
- [ ] Operation completes in <3 seconds
- [ ] Success notification/feedback
- [ ] **Pick up iPhone**: Instagram, TikTok, Twitter apps are GONE
- [ ] Check Safari: instagram.com is blocked
- [ ] Button changes to "Unshift iPhone"
- [ ] Status shows "Phone is Shifted"

### ✅ Basic Unshift Test
- [ ] Click "Unshift iPhone" button
- [ ] Button shows loading state ("Unshifting...")
- [ ] Operation completes in <3 seconds
- [ ] Success notification/feedback
- [ ] **Pick up iPhone**: Apps reappear on home screen
- [ ] Check Safari: instagram.com works again
- [ ] Button changes to "Shift iPhone"
- [ ] Status shows "Phone is Unshifted"

### ✅ Rapid Shift/Unshift Tests
- [ ] Shift → Unshift → Shift → Unshift (quickly)
- [ ] No crashes or errors
- [ ] iPhone stays in sync with button state
- [ ] No "stuck" profiles on iPhone

### ✅ Shift During Disconnect
- [ ] Start shift operation
- [ ] Disconnect iPhone during shift
- [ ] App shows appropriate error
- [ ] App doesn't crash
- [ ] Reconnect iPhone and retry → works

---

## ⏱️ Phase 4: Focus Session Tests

### ✅ No Timer Test (Default)
- [ ] "No Timer" is selected by default
- [ ] Shift iPhone
- [ ] Unshift button is immediately available
- [ ] Can unshift right away

### ✅ 30-Minute Session Test
- [ ] Select "30 min" option
- [ ] Click "Shift iPhone"
- [ ] iPhone shifts successfully
- [ ] Unshift button becomes disabled
- [ ] Countdown shows "Session ends in 29:xx"
- [ ] Countdown updates every second
- [ ] After 1 minute, countdown shows "28:xx"
- [ ] **Quit and relaunch app** → Countdown persists
- [ ] Wait for timer to expire (or fast-forward system time)
- [ ] Unshift button re-enables
- [ ] Can unshift after timer expires

### ✅ 60-Minute Session Test
- [ ] Select "60 min" option
- [ ] Shift with timer
- [ ] Countdown shows correctly
- [ ] Works as expected

### ✅ 90-Minute Session Test
- [ ] Select "90 min" option
- [ ] Shift with timer
- [ ] Countdown shows 1:29:xx format
- [ ] Works as expected

### ✅ Manual Override Test
- [ ] Start focus session (30 min)
- [ ] Expand Emergency panel
- [ ] Click "End Focus Session"
- [ ] Confirm in dialog
- [ ] Session ends immediately
- [ ] Unshift button re-enables
- [ ] Can unshift successfully

### ✅ Focus Session Edge Cases
- [ ] Start session → Quit app → Relaunch → Session persists
- [ ] Start session → Restart Mac → Session persists
- [ ] Multiple sessions in sequence work
- [ ] Changing duration mid-session (shouldn't be possible)

---

## 📅 Phase 5: Schedule Tests

### ✅ Create Schedule Test
- [ ] Go to Schedule tab
- [ ] Click "Add Schedule"
- [ ] Select "Shift" action
- [ ] Set time to 1 minute in future
- [ ] Select "All Days"
- [ ] Click "Save"
- [ ] Schedule appears in list
- [ ] Shows correct time and days

### ✅ Schedule Trigger Test
- [ ] Create schedule for 1 minute from now
- [ ] Wait for scheduled time
- [ ] iPhone shifts automatically
- [ ] Notification appears (optional, if implemented)
- [ ] Status updates to "Shifted"

### ✅ Schedule Management Tests
- [ ] Create multiple schedules
- [ ] Toggle schedule on/off
- [ ] Disabled schedule doesn't trigger
- [ ] Delete schedule
- [ ] Edit existing schedule (if implemented)

### ✅ Schedule Edge Cases
- [ ] Create schedule for past time → Doesn't trigger until next day
- [ ] Two schedules at same time → Both execute
- [ ] Schedule while Mac is asleep → Triggers when Mac wakes
- [ ] Schedule while iPhone disconnected → Shows error, retries

### ✅ Weekly Schedule Patterns
- [ ] "Every day" schedule works
- [ ] "Weekdays" (Mon-Fri) schedule works
- [ ] "Weekends" (Sat-Sun) schedule works
- [ ] Custom days selection works
- [ ] Schedule respects day settings

---

## ⚙️ Phase 6: Settings/Customization Tests

### ✅ App List Loading
- [ ] Go to Settings tab
- [ ] Click "Refresh Apps"
- [ ] Loading indicator appears
- [ ] Apps fetch from iPhone
- [ ] Apps populate in categories
- [ ] Each app shows name and bundle ID

### ✅ Category Display Tests
- [ ] Social Media category shows correct apps
- [ ] Entertainment category shows correct apps
- [ ] Productivity category shows correct apps
- [ ] Essential category shows system apps
- [ ] Games category shows games
- [ ] Uncategorized catches unknown apps

### ✅ App Toggle Tests
- [ ] Toggle Instagram off (allow when shifted)
- [ ] Save and shift iPhone
- [ ] Instagram remains visible on iPhone
- [ ] Toggle Instagram back on (block when shifted)
- [ ] Shift again → Instagram disappears

### ✅ Domain Blocking Tests
- [ ] Add custom domain (e.g., "reddit.com")
- [ ] Shift iPhone
- [ ] Check Safari: reddit.com is blocked
- [ ] Unshift → reddit.com works again
- [ ] Remove domain from list
- [ ] Domain unblocks on next shift

### ✅ App Search Test
- [ ] Search for "Instagram"
- [ ] Only Instagram shows in list
- [ ] Clear search → All apps return
- [ ] Search is case-insensitive

### ✅ Settings Persistence
- [ ] Change app settings
- [ ] Quit app
- [ ] Relaunch app
- [ ] Settings are preserved

---

## 🚨 Phase 7: Emergency Features Tests

### ✅ Emergency Panel Tests
- [ ] Panel is collapsed by default
- [ ] Click to expand → Shows danger zone
- [ ] Warning text is clear
- [ ] Red "Remove Supervision" button visible

### ✅ Remove Supervision Test (CAREFUL!)
- [ ] Click "Remove All Supervision"
- [ ] Dialog asks for confirmation
- [ ] Must type "REMOVE" to confirm
- [ ] Cancel button works
- [ ] Type "REMOVE" → Supervision removes
- [ ] iPhone shows "Not supervised" in Settings → About
- [ ] FocusShift can no longer control iPhone
- [ ] App shows appropriate message

### ✅ Emergency During Focus Session
- [ ] Start focus session
- [ ] Try to unshift → Button disabled
- [ ] Open Emergency panel → Manual override available
- [ ] End session manually → Works

---

## 🐛 Error Handling Tests

### ✅ Network/Connection Errors
- [ ] Shift with iPhone disconnected → Clear error message
- [ ] Unshift with iPhone disconnected → Clear error
- [ ] Operation interrupted → App recovers gracefully

### ✅ Profile Errors
- [ ] Profile installation fails → Error shown to user
- [ ] Profile removal fails → Error shown
- [ ] Conflicting profiles → Handled correctly

### ✅ Permission Errors
- [ ] cfgutil permission denied → Clear error message
- [ ] iPhone refuses profile → Error handled

---

## 🎨 UI/UX Tests

### ✅ Visual Design
- [ ] Colors match design system (see PRD)
- [ ] Buttons have correct colors (blue/purple/red)
- [ ] Icons are clear and appropriate
- [ ] Text is readable
- [ ] Spacing and padding look good

### ✅ Animations
- [ ] Button press animations work
- [ ] Tab switching is smooth
- [ ] Loading indicators spin
- [ ] Status indicator pulses when searching

### ✅ Accessibility
- [ ] All text is readable
- [ ] Buttons are large enough to click
- [ ] Keyboard navigation works
- [ ] Error messages are clear

---

## ⚡ Performance Tests

### ✅ Speed Tests
- [ ] Shift completes in <3 seconds
- [ ] Unshift completes in <3 seconds
- [ ] App launches in <2 seconds
- [ ] Tab switching is instant
- [ ] No lag or freezing

### ✅ Resource Usage
- [ ] App uses <50MB RAM when idle
- [ ] CPU usage is low when idle
- [ ] No memory leaks (use Instruments if needed)
- [ ] Battery drain is minimal

---

## 🔁 Stress Tests

### ✅ Reliability Tests
- [ ] 10 shift/unshift cycles in a row → No failures
- [ ] Run app for 1 hour → No crashes
- [ ] Create 20 schedules → App performs well
- [ ] Fetch 100+ apps → UI remains responsive

### ✅ Edge Case Tests
- [ ] Shift while already shifted → Handled gracefully
- [ ] Unshift while already unshifted → No error
- [ ] Multiple Macs trying to control same iPhone → ???
- [ ] iPhone runs out of battery during shift → Recovers on reconnect

---

## 📊 Final Acceptance Tests

### ✅ Core Use Case: "I need to focus for 1 hour"
- [ ] Open FocusShift
- [ ] Select 60 min
- [ ] Click Shift
- [ ] iPhone blocks distractions
- [ ] Timer locks unshift for 1 hour
- [ ] After 1 hour, can unshift
- [ ] Apps return normally

### ✅ Core Use Case: "Auto-shift every weeknight at 9pm"
- [ ] Create schedule: Shift at 9:00 PM, Mon-Fri
- [ ] Wait for 9pm on a weekday
- [ ] iPhone shifts automatically
- [ ] No manual intervention needed

### ✅ Core Use Case: "I need to customize blocked apps"
- [ ] Open Settings
- [ ] Whitelist YouTube (need it for work)
- [ ] Shift iPhone
- [ ] YouTube remains accessible
- [ ] Other social media is blocked

---

## ✅ Sign-Off Criteria

**Phase 1 Complete** when:
- All Build & Launch tests pass
- UI is functional
- No crashes

**Phase 2 Complete** when:
- iPhone detection works reliably
- Connection edge cases handled

**Phase 3 Complete** when:
- Shift/Unshift works 100% of the time
- Apps disappear/reappear correctly
- Domains are blocked/unblocked

**Phase 4 Complete** when:
- All focus session durations work
- Timer countdown is accurate
- Sessions persist across app restarts

**Phase 5 Complete** when:
- Schedules trigger automatically
- Schedule management works
- Edge cases handled

**Phase 6 Complete** when:
- Apps can be customized
- Domain blocking works
- Settings persist

**Phase 7 Complete** when:
- Emergency features work
- All error handling is robust
- Performance is acceptable

---

## 🎉 FocusShift is READY when:
- ✅ All core features work reliably
- ✅ No critical bugs or crashes
- ✅ Performance is good
- ✅ User experience is smooth
- ✅ You trust it to manage your phone!

**Then**: Ship it and start using it daily! 🚀

---

**Testing Notes**:
- Test on real device, not simulator
- Test with iPhone you'll actually use
- Test during different times of day
- Use it for real work to find edge cases
- Document any bugs you find

**Remember**: Perfect is the enemy of good. Ship when it works for YOUR use case, improve later!
