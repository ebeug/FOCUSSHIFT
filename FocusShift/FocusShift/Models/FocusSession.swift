//
//  FocusSession.swift
//  FocusShift
//
//  Represents an active focus session with a timer that prevents unshifting
//

import Foundation

struct FocusSession: Codable {
    let startedAt: Date
    let endsAt: Date

    // Is this session currently active?
    var isActive: Bool {
        Date() < endsAt
    }

    // How many seconds are remaining in the session?
    var remainingSeconds: Int {
        max(0, Int(endsAt.timeIntervalSince(Date())))
    }

    // Format remaining time as MM:SS or HH:MM:SS
    var remainingTimeString: String {
        let seconds = remainingSeconds
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%d:%02d", minutes, secs)
        }
    }

    // Duration of the session in minutes
    var durationMinutes: Int {
        Int(endsAt.timeIntervalSince(startedAt) / 60)
    }
}
