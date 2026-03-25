//
//  WorkoutView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: WorkoutViewModel
    @State private var showExerciseLibrary = false
    @State private var showWorkoutSummary = false

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isWorkoutInProgress {
                    activeWorkoutView
                } else {
                    startWorkoutView
                }
            }
            .navigationTitle("Workout")
            .toolbar {
                if viewModel.isWorkoutInProgress {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("End") {
                            showWorkoutSummary = true
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .sheet(isPresented: $showExerciseLibrary) {
                ExerciseLibraryView(onSelectExercise: { exercise in
                    if !viewModel.selectedExercises.contains(exercise.name) {
                        viewModel.selectedExercises.append(exercise.name)
                    }
                    showExerciseLibrary = false
                })
            }
            .sheet(isPresented: $showWorkoutSummary) {
                WorkoutSummaryView(workout: viewModel.currentWorkout) {
                    viewModel.endWorkout(context: modelContext)
                    showWorkoutSummary = false
                } onCancel: {
                    showWorkoutSummary = false
                }
            }
        }
    }

    private var startWorkoutView: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text("Ready to work out?")
                .font(.title2)
                .fontWeight(.semibold)

            Button(action: {
                viewModel.startWorkout()
            }) {
                Text("Start Workout")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 40)
        }
    }

    private var activeWorkoutView: some View {
        VStack {
            if viewModel.selectedExercises.isEmpty {
                emptyExerciseView
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.selectedExercises, id: \.self) { exerciseName in
                            ExerciseCard(
                                exerciseName: exerciseName,
                                sets: viewModel.getSetsForExercise(exerciseName),
                                onAddSet: { reps, weight in
                                    viewModel.addSet(
                                        exerciseName: exerciseName,
                                        reps: reps,
                                        weight: weight,
                                        context: modelContext
                                    )
                                }
                            )
                        }
                    }
                    .padding()
                }
            }

            Button(action: {
                showExerciseLibrary = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Exercise")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
    }

    private var emptyExerciseView: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("No exercises yet")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Add an exercise to get started")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    WorkoutView(viewModel: WorkoutViewModel())
        .modelContainer(for: [Workout.self, Exercise.self], inMemory: true)
}
