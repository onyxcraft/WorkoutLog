//
//  HistoryView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]

    @State private var selectedDate: Date?
    @State private var showCalendarView = false

    var body: some View {
        NavigationStack {
            Group {
                if workouts.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(groupedWorkouts.keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(formatSectionDate(date))) {
                                ForEach(groupedWorkouts[date] ?? []) { workout in
                                    WorkoutRow(workout: workout)
                                }
                                .onDelete { indexSet in
                                    deleteWorkouts(at: indexSet, in: groupedWorkouts[date] ?? [])
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showCalendarView = true
                    }) {
                        Image(systemName: "calendar")
                    }
                }
            }
            .sheet(isPresented: $showCalendarView) {
                CalendarView(workouts: workouts)
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("No Workouts Yet")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Your workout history will appear here")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
    }

    private var groupedWorkouts: [Date: [Workout]] {
        Dictionary(grouping: workouts) { workout in
            Calendar.current.startOfDay(for: workout.date)
        }
    }

    private func formatSectionDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }

    private func deleteWorkouts(at offsets: IndexSet, in workouts: [Workout]) {
        for index in offsets {
            modelContext.delete(workouts[index])
        }
    }
}

struct WorkoutRow: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(formatTime(workout.date))
                    .font(.headline)

                Spacer()

                Text("\(Int(workout.duration / 60)) min")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                Label("\(workout.totalSets)", systemImage: "square.stack.3d.up")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Label("\(workout.totalReps)", systemImage: "repeat")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Label("\(Int(workout.totalVolume)) lbs", systemImage: "arrow.up.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if !workout.exerciseNames.isEmpty {
                Text(workout.exerciseNames.joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [Workout.self], inMemory: true)
}
