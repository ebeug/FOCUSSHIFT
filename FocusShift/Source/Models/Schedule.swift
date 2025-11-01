//
//  Schedule.swift
//  FocusShift
//
//  Represents a scheduled automatic shift or unshift
//

import Foundation

struct Schedule: Identifiable, Codable {
    let id: UUID
    var action: ScheduleAction      // Should this shift or unshift?
    var time: DateComponents        // What time should it trigger? (hour + minute)
    var days: Set<Weekday>          // Which days of the week?
    var isEnabled: Bool             // Is this schedule active?

    enum ScheduleAction: String, Codable {
        case shift
        case unshift

        var displayName: String {
            switch self {
            case .shift:
                return "Shift"
            case .unshift:
                return "Unshift"
            }
        }
    }

    enum Weekday: Int, Codable, CaseIterable, Hashable {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7

        var shortName: String {
            switch self {
            case .sunday: return "S"
            case .monday: return "M"
            case .tuesday: return "T"
            case .wednesday: return "W"
            case .thursday: return "T"
            case .friday: return "F"
            case .saturday: return "S"
            }
        }

        var fullName: String {
            switch self {
            case .sunday: return "Sunday"
            case .monday: return "Monday"
            case .tuesday: return "Tuesday"
            case .wednesday: return "Wednesday"
            case .thursday: return "Thursday"
            case .friday: return "Friday"
            case .saturday: return "Saturday"
            }
        }
    }

    // Check if this schedule should trigger right now
    func shouldTriggerNow() -> Bool {
        guard isEnabled else { return false }

        let now = Date()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.hour, .minute, .weekday], from: now)

        // Check if current weekday matches any of the schedule's days
        guard let currentWeekday = currentComponents.weekday,
              let weekday = Weekday(rawValue: currentWeekday),
              days.contains(weekday) else {
            return false
        }

        // Check if current hour and minute match the schedule time
        guard let scheduleHour = time.hour,
              let scheduleMinute = time.minute,
              let currentHour = currentComponents.hour,
              let currentMinute = currentComponents.minute else {
            return false
        }

        return currentHour == scheduleHour && currentMinute == scheduleMinute
    }

    // Display string for the schedule time
    var timeString: String {
        guard let hour = time.hour, let minute = time.minute else {
            return "Invalid time"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        if let date = Calendar.current.date(from: components) {
            return formatter.string(from: date)
        }

        return "\(hour):\(String(format: "%02d", minute))"
    }

    // Display string for the days
    var daysString: String {
        if days.count == 7 {
            return "Every day"
        } else if days == [.monday, .tuesday, .wednesday, .thursday, .friday] {
            return "Weekdays"
        } else if days == [.saturday, .sunday] {
            return "Weekends"
        } else {
            return days.sorted(by: { $0.rawValue < $1.rawValue })
                .map { $0.shortName }
                .joined(separator: ", ")
        }
    }
}
