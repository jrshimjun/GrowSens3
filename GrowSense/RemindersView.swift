//
//  RemindersView.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//

import SwiftUI
import UserNotifications

struct Reminder: Identifiable, Codable, Equatable {
    var id: String
    var date: Date
    var interval: RepeatInterval
}

enum RepeatInterval: String, CaseIterable, Codable, Identifiable {
    var id: String { self.rawValue }

    case none = "Once"
    case daily = "Daily"
    case weekly = "Weekly"
    case biweekly = "Every 2 Weeks"

    var description: String {
        switch self {
        case .none: return "Once"
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .biweekly: return "Biweekly"
        }
    }
}

struct RemindersView: View {
    @State private var reminders: [Reminder] = []
    @State private var showingAddReminder = false
    @State private var newReminderDate = Date()
    @State private var newRepeatInterval: RepeatInterval = .none

    var body: some View {
        NavigationView {
            List {
                ForEach(reminders) { reminder in
                    VStack(alignment: .leading) {
                        Text(formattedDate(reminder.date))
                            .font(.body)
                        if reminder.interval != .none {
                            Text("Repeats: \(reminder.interval.description)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteReminder)
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddReminder = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                VStack(spacing: 20) {
                    DatePicker("Select Date & Time", selection: $newReminderDate)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding()

                    Picker("Repeat", selection: $newRepeatInterval) {
                        ForEach(RepeatInterval.allCases) { interval in
                            Text(interval.description).tag(interval)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Button("Save Reminder") {
                        addReminder(for: newReminderDate, repeatInterval: newRepeatInterval)
                        showingAddReminder = false
                        newRepeatInterval = .none
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)

                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            loadReminders()
        }
    }


    func addReminder(for date: Date, repeatInterval: RepeatInterval) {
        let id = UUID().uuidString
        let newReminder = Reminder(id: id, date: date, interval: repeatInterval)
        reminders.append(newReminder)
        saveReminders()
        scheduleNotification(for: newReminder)
    }

    func deleteReminder(at offsets: IndexSet) {
        offsets.forEach { index in
            let reminder = reminders[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id])
        }
        reminders.remove(atOffsets: offsets)
        saveReminders()
    }


    func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Water Your Plant"
        content.body = "It's time to water your plants!"
        content.sound = UNNotificationSound.default

        var trigger: UNNotificationTrigger?

        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .month, .year, .weekday], from: reminder.date)

        switch reminder.interval {
        case .none:
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        case .daily:
            let dailyComponents = DateComponents(hour: components.hour, minute: components.minute)
            trigger = UNCalendarNotificationTrigger(dateMatching: dailyComponents, repeats: true)
        case .weekly:
            guard let weekday = calendar.dateComponents([.weekday], from: reminder.date).weekday else { return }
            let weeklyComponents = DateComponents(hour: components.hour, minute: components.minute, weekday: weekday)
            trigger = UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
        case .biweekly:
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        }

        if let trigger = trigger {
            let request = UNNotificationRequest(identifier: reminder.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to schedule: \(error.localizedDescription)")
                }
            }
        }
    }


    func saveReminders() {
        if let data = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(data, forKey: "reminders")
        }
    }

    func loadReminders() {
        if let data = UserDefaults.standard.data(forKey: "reminders"),
           let saved = try? JSONDecoder().decode([Reminder].self, from: data) {
            reminders = saved
        }
    }


    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
