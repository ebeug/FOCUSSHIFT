//
//  FocusShiftApp.swift
//  FocusShift
//
//  Main app entry point
//

import SwiftUI

@main
struct FocusShiftApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 700, minHeight: 500)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Start schedule monitoring
        ScheduleManager.shared.startMonitoring()
        print("✅ FocusShift started. Schedule monitoring active.")
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Stop schedule monitoring
        ScheduleManager.shared.stopMonitoring()
        print("👋 FocusShift terminated.")
    }
}
