//
//  CalendarView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI

struct CalendarView: View {
    let workouts: [Workout]
    @Environment(\.dismiss) private var dismiss

    @State private var currentMonth = Date()

    var body: some View {
        NavigationStack {
            VStack {
                monthPicker

                calendarGrid

                Spacer()
            }
            .padding()
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var monthPicker: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(monthYearString)
                .font(.headline)

            Spacer()

            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
    }

    private var calendarGrid: some View {
        let days = daysInMonth()
        let firstWeekday = firstWeekdayOfMonth()

        return VStack(spacing: 8) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(0..<firstWeekday, id: \.self) { _ in
                    Text("")
                        .frame(height: 40)
                }

                ForEach(1...days, id: \.self) { day in
                    let date = dateForDay(day)
                    let hasWorkout = workoutsOnDate(date).count > 0

                    VStack(spacing: 4) {
                        Text("\(day)")
                            .font(.system(size: 14))
                            .frame(width: 32, height: 32)
                            .background(hasWorkout ? Color.blue.opacity(0.3) : Color.clear)
                            .clipShape(Circle())

                        if hasWorkout {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 4, height: 4)
                        }
                    }
                    .frame(height: 40)
                }
            }
        }
    }

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }

    private func daysInMonth() -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: currentMonth)
        return range?.count ?? 30
    }

    private func firstWeekdayOfMonth() -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        let firstDay = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: firstDay) - 1
    }

    private func dateForDay(_ day: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }

    private func workoutsOnDate(_ date: Date) -> [Workout] {
        workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    private func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }

    private func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
}

#Preview {
    CalendarView(workouts: [])
}
