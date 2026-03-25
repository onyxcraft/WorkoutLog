//
//  ProgressView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI
import SwiftData
import Charts

struct ProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]
    @Query private var personalRecords: [PersonalRecord]
    @Query private var exercises: [Exercise]

    @State private var selectedExercise: Exercise?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    personalRecordsSection

                    if let selectedExercise = selectedExercise {
                        exerciseProgressChart(exercise: selectedExercise)
                    } else {
                        emptyChartView
                    }
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }

    private var personalRecordsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personal Records")
                .font(.headline)

            if personalRecords.isEmpty {
                Text("No personal records yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(personalRecords) { pr in
                            PRCard(personalRecord: pr)
                        }
                    }
                }
            }

            Divider()
                .padding(.vertical, 8)

            Text("Exercise Progress")
                .font(.headline)

            Menu {
                ForEach(exercises) { exercise in
                    Button(exercise.name) {
                        selectedExercise = exercise
                    }
                }
            } label: {
                HStack {
                    Text(selectedExercise?.name ?? "Select an exercise")
                        .foregroundStyle(selectedExercise == nil ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var emptyChartView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)

            Text("Select an exercise to view progress")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func exerciseProgressChart(exercise: Exercise) -> some View {
        let data = getChartData(for: exercise.name)

        return VStack(alignment: .leading, spacing: 12) {
            if data.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)

                    Text("No data for \(exercise.name)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weight Progression")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Chart(data) { item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Weight", item.weight)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", item.date),
                            y: .value("Weight", item.weight)
                        )
                        .foregroundStyle(.blue)
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .automatic) { _ in
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Reps Progression")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Chart(data) { item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Reps", item.reps)
                        )
                        .foregroundStyle(.green)
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", item.date),
                            y: .value("Reps", item.reps)
                        )
                        .foregroundStyle(.green)
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .automatic) { _ in
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func getChartData(for exerciseName: String) -> [ExerciseDataPoint] {
        var dataPoints: [ExerciseDataPoint] = []

        for workout in workouts.reversed() {
            let sets = workout.sets.filter { $0.exerciseName == exerciseName }

            if let maxWeightSet = sets.max(by: { $0.weight < $1.weight }) {
                dataPoints.append(ExerciseDataPoint(
                    date: workout.date,
                    weight: maxWeightSet.weight,
                    reps: maxWeightSet.reps
                ))
            }
        }

        return dataPoints
    }
}

struct ExerciseDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
    let reps: Int
}

struct PRCard: View {
    let personalRecord: PersonalRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundStyle(.yellow)
                Text("PR")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.yellow)
            }

            Text(personalRecord.exerciseName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)

            HStack(spacing: 4) {
                Text("\(Int(personalRecord.maxWeight)) lbs")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("×")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(personalRecord.maxReps)")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            Text(formatDate(personalRecord.achievedDate))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 180)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ProgressView()
        .modelContainer(for: [Workout.self, PersonalRecord.self, Exercise.self], inMemory: true)
}
