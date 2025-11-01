# Git Commit Strategy for FocusShift

## 🎯 When to Commit & Push

### After Each Major Milestone:

- ✅ **Phase 1 Complete** - All source files created (DONE!)
- ⏳ **Xcode Project Created** - When .xcodeproj is set up and builds
- ⏳ **First Successful Shift** - When iPhone shifts for the first time
- ⏳ **Focus Sessions Working** - When timer-based locking works
- ⏳ **Schedules Working** - When automatic shifts trigger
- ⏳ **App Customization Working** - When can fetch and customize app list
- ⏳ **UI Polish Complete** - When design system is fully applied
- ⏳ **Testing Complete** - When all edge cases are handled

### After Bug Fixes:

- Fix any crash or major bug → Commit immediately
- Fix any blocking issue → Commit immediately

### Daily Commits:

At the end of each coding session, commit your work even if incomplete:
```bash
git add -A
git commit -m "WIP: [describe what you worked on]"
git push
```

---

## 📝 Commit Message Template

### For Features:
```bash
git commit -m "feat: [Short description]

- What was added
- Why it matters
- What works now

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

### For Fixes:
```bash
git commit -m "fix: [What was broken]

- Root cause
- Solution applied
- What was tested

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

### For WIP (Work in Progress):
```bash
git commit -m "WIP: [What you're working on]

Current status:
- What's done
- What's left

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## 🚨 IMPORTANT: I Will Remind You!

Every time we complete a major feature or phase, I will:
1. ✅ Tell you explicitly: "Let's commit this!"
2. ✅ Write the commit message
3. ✅ Push to GitHub
4. ✅ Confirm it's saved

You don't have to remember - I'll handle it! 💪

---

## 🔄 Quick Commands

### Check status:
```bash
git status
```

### See recent commits:
```bash
git log --oneline -5
```

### Push latest changes:
```bash
git push
```

### See what changed:
```bash
git diff
```

---

## 📊 Current Status

**Latest Commit**: Initial commit with all Phase 1 source files
**Remote**: https://github.com/ebeug/FOCUSSHIFT
**Branch**: main
**Files Tracked**: 19 files (4,088 lines of code)

**Next Commit**: After Xcode project is created and first build succeeds
