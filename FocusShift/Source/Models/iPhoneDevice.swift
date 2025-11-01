//
//  iPhoneDevice.swift
//  FocusShift
//
//  Represents the connected iPhone and its current state
//

import Foundation

struct iPhoneDevice: Identifiable {
    let id: String              // UDID (Unique Device Identifier)
    let name: String            // Device name (e.g., "Ethan's iPhone")
    var isConnected: Bool       // Is the iPhone currently connected?
    var isShifted: Bool         // Is the iPhone currently in shifted (focus) mode?
    var lastSeenAt: Date        // Last time the device was detected

    // Computed property for display purposes
    var statusText: String {
        if !isConnected {
            return "Disconnected"
        }
        return isShifted ? "Shifted (Focus Mode)" : "Unshifted (Normal Mode)"
    }
}
