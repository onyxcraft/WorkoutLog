//
//  WorkoutSummaryView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI

struct WorkoutSummaryView: View {
    let workout: Workout?
    let onSave: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    summaryHeader

                    statsGrid

                    if let workout = workout {
                        exerciseBreakdown(workout: workout)
                    }
                }
                .padding()
            }
            .navigationTitle("Workout Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                }
            }
        }
    }

    private var summaryHeader: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)

            Text("Great Workout!")
                .font(.title2)
                .fontWeight(.bold)
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(
                title: "Total Sets",
                value: "\(workout?.totalSets ?? 0)",
                icon: "square.stack.3d.up.fill",
                color: .blue
            )

            StatCard(
                title: "Total Reps",
                value: "\(workout?.totalReps ?? 0)",
                icon: "repeat",
                color: .green
            )

            StatCard(
                title: "Total Volume",
                value: "\(Int(workout?.totalVolume ?? 0)) lbs",
                icon: "arrow.up.circle.fill",
                color: .orange
            )

            StatCard(
                title: "Duration",
                value: formatDuration(workout?.duration ?? 0),
                icon: "clock.fill",
                color: .purple
            )
        }
    }

    private func exerciseBreakdown(workout: Workout) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Exercises")
                .font(.headline)

            ForEach(workout.exerciseNames, id: \.self) { exerciseName in
                let sets = workout.sets.filter { $0.exerciseName == exerciseName }
                VStack(alignment: .leading, spacing: 8) {
                    Text(exerciseName)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    ForEach(Array(sets.enumerated()), id: \.element.id) { index, set in
                        HStack {
                            Text("Set \(index + 1)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 50, alignment: .leading)

                            Spacer()

                            Text("\(set.reps) reps × \(Int(set.weight)) lbs")
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes) min"
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    WorkoutSummaryView(
        workout: Workout(),
        onSave: {},
        onCancel: {}
    )
}
