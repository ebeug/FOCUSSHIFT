#!/bin/bash

# FocusShift Xcode Project Setup Script
# This script helps set up the Xcode project structure

set -e  # Exit on any error

echo "🚀 Setting up FocusShift Xcode Project..."
echo ""

PROJECT_DIR="/Users/ethanli/Documents/Code/FOCUSSHIFT"
cd "$PROJECT_DIR"

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed or xcodebuild is not in PATH"
    exit 1
fi

echo "✅ Xcode is installed"
echo ""

# Open Xcode to create the project
echo "📝 Next Steps:"
echo ""
echo "1. Xcode will open in a moment"
echo "2. Click 'Create New Project' or File > New > Project"
echo "3. Select 'macOS' tab at the top"
echo "4. Choose 'App' template"
echo "5. Click 'Next'"
echo ""
echo "6. Fill in these details:"
echo "   - Product Name: FocusShift"
echo "   - Team: None (or your team)"
echo "   - Organization Identifier: com.focusshift"
echo "   - Interface: SwiftUI ⚠️ IMPORTANT!"
echo "   - Language: Swift ⚠️ IMPORTANT!"
echo "   - Storage: None"
echo "   - Uncheck 'Create Git repository' (we already have one)"
echo ""
echo "7. Click 'Next'"
echo "8. Save in: $PROJECT_DIR"
echo "   ⚠️ IMPORTANT: Save it IN the FOCUSSHIFT folder, NOT in a subfolder!"
echo ""
echo "9. Press Enter here when done, and I'll help add the source files..."
echo ""

# Open Xcode
open -a Xcode

echo "Press Enter when you've created the project..."
read -r

echo ""
echo "Great! Now let's verify the project was created..."
echo ""

if [ ! -f "FocusShift.xcodeproj/project.pbxproj" ]; then
    echo "❌ Project file not found. Make sure you saved it in the right location."
    echo "Expected location: $PROJECT_DIR/FocusShift.xcodeproj"
    exit 1
fi

echo "✅ Project file found!"
echo ""
echo "🎉 Next: I'll help you add the source files to the project."
echo "   Follow the instructions in the terminal after this script completes."
