//
//  ScheduleView.swift
//  FocusShift
//
//  Schedule screen for managing automatic shifts
//

import SwiftUI

struct ScheduleView: View {
    @StateObject private var scheduleManager = ScheduleManager.shared
    @State private var showingAddSheet = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Automatic Schedules")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                    showingAddSheet = true
                }) {
                    Label("Add Schedule", systemImage: "plus")
                }
            }
            .padding()

            Divider()

            // Schedule list
            if scheduleManager.schedules.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)

                    Text("No schedules yet")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text("Create a schedule to automatically shift your iPhone at specific times")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(scheduleManager.schedules) { schedule in
                            ScheduleCardView(schedule: schedule)
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddScheduleView(isPresented: $showingAddSheet)
        }
    }
}

// MARK: - Schedule Card

struct ScheduleCardView: View {
    let schedule: Schedule
    @StateObject private var scheduleManager = ScheduleManager.shared

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(schedule.action.displayName)
                        .font(.headline)
                        .foregroundColor(schedule.action == .shift ? .purple : .blue)

                    Text("at \(schedule.timeString)")
                        .font(.headline)
                }

                Text(schedule.daysString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Toggle("", isOn: binding(for: schedule))
                .labelsHidden()

            Button(action: {
                scheduleManager.removeSchedule(id: schedule.id)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color(.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private func binding(for schedule: Schedule) -> Binding<Bool> {
        Binding(
            get: { schedule.isEnabled },
            set: { _ in
                scheduleManager.toggleSchedule(id: schedule.id)
            }
        )
    }
}

// MARK: - Add Schedule Sheet

struct AddScheduleView: View {
    @Binding var isPresented: Bool
    @StateObject private var scheduleManager = ScheduleManager.shared

    @State private var action: Schedule.ScheduleAction = .shift
    @State private var hour: Int = 21  // 9 PM
    @State private var minute: Int = 0
    @State private var selectedDays: Set<Schedule.Weekday> = Set(Schedule.Weekday.allCases)

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Schedule")
                .font(.title2)
                .fontWeight(.bold)

            Form {
                // Action picker
                Picker("Action", selection: $action) {
                    ForEach([Schedule.ScheduleAction.shift, .unshift], id: \.self) { action in
                        Text(action.displayName).tag(action)
                    }
                }
                .pickerStyle(.segmented)

                // Time picker
                HStack {
                    Text("Time")
                    Spacer()
                    Picker("Hour", selection: $hour) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text(String(format: "%02d", hour)).tag(hour)
                        }
                    }
                    .frame(width: 60)

                    Text(":")

                    Picker("Minute", selection: $minute) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .frame(width: 60)
                }

                // Day selector
                VStack(alignment: .leading) {
                    Text("Days")
                        .font(.headline)

                    HStack {
                        ForEach(Schedule.Weekday.allCases, id: \.self) { day in
                            Button(action: {
                                toggleDay(day)
                            }) {
                                Text(day.shortName)
                                    .font(.caption)
                                    .frame(width: 30, height: 30)
                                    .background(selectedDays.contains(day) ? Color.purple : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                                    .cornerRadius(15)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()

            // Buttons
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Save") {
                    saveSchedule()
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
                .disabled(selectedDays.isEmpty)
            }
            .padding()
        }
        .frame(width: 400, height: 400)
    }

    private func toggleDay(_ day: Schedule.Weekday) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }

    private func saveSchedule() {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let schedule = Schedule(
            id: UUID(),
            action: action,
            time: components,
            days: selectedDays,
            isEnabled: true
        )

        scheduleManager.addSchedule(schedule)
    }
}

#Preview {
    ScheduleView()
        .frame(width: 600, height: 500)
}
