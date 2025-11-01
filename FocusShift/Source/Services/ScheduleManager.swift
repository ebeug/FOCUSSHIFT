//
//  ScheduleManager.swift
//  FocusShift
//
//  Manages scheduled automatic shifts and unshifts
//

import Foundation
import Combine

class ScheduleManager: ObservableObject {
    static let shared = ScheduleManager()

    @Published var schedules: [Schedule] = []

    private var timer: Timer?
    private let deviceManager = DeviceManager()

    init() {
        // Load saved schedules
        schedules = PreferencesManager.shared.loadSchedules()
    }

    // MARK: - Schedule Management

    func addSchedule(_ schedule: Schedule) {
        schedules.append(schedule)
        saveSchedules()
    }

    func updateSchedule(_ schedule: Schedule) {
        if let index = schedules.firstIndex(where: { $0.id == schedule.id }) {
            schedules[index] = schedule
            saveSchedules()
        }
    }

    func removeSchedule(id: UUID) {
        schedules.removeAll(where: { $0.id == id })
        saveSchedules()
    }

    func toggleSchedule(id: UUID) {
        if let index = schedules.firstIndex(where: { $0.id == id }) {
            schedules[index].isEnabled.toggle()
            saveSchedules()
        }
    }

    private func saveSchedules() {
        PreferencesManager.shared.saveSchedules(schedules)
    }

    // MARK: - Background Timer

    func startMonitoring() {
        // Check every 60 seconds if any schedule should trigger
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkSchedules()
        }
        // Also check immediately
        checkSchedules()
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    private func checkSchedules() {
        let enabledSchedules = schedules.filter { $0.isEnabled }

        for schedule in enabledSchedules {
            if schedule.shouldTriggerNow() {
                Task {
                    await executeSchedule(schedule)
                }
            }
        }
    }

    private func executeSchedule(_ schedule: Schedule) async {
        print("⏰ Executing schedule: \(schedule.action.displayName) at \(schedule.timeString)")

        do {
            switch schedule.action {
            case .shift:
                try await deviceManager.shiftDevice()
                print("✅ Scheduled shift completed")
            case .unshift:
                try await deviceManager.unshiftDevice()
                print("✅ Scheduled unshift completed")
            }
        } catch {
            print("❌ Scheduled action failed: \(error.localizedDescription)")
        }
    }
}
