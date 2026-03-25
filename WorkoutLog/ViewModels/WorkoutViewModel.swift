//
//  WorkoutViewModel.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
final class WorkoutViewModel {
    var currentWorkout: Workout?
    var selectedExercises: [String] = []
    var startTime: Date?
    var isWorkoutInProgress = false

    func startWorkout() {
        currentWorkout = Workout(date: Date())
        startTime = Date()
        isWorkoutInProgress = true
    }

    func addSet(exerciseName: String, reps: Int, weight: Double, context: ModelContext) {
        guard let workout = currentWorkout else { return }

        let setOrder = workout.sets.filter { $0.exerciseName == exerciseName }.count
        let newSet = WorkoutSet(reps: reps, weight: weight, exerciseName: exerciseName, order: setOrder)

        workout.sets.append(newSet)

        if !selectedExercises.contains(exerciseName) {
            selectedExercises.append(exerciseName)
        }

        checkAndUpdatePR(exerciseName: exerciseName, weight: weight, reps: reps, context: context)
    }

    func endWorkout(context: ModelContext) {
        guard let workout = currentWorkout, let start = startTime else { return }

        workout.duration = Date().timeIntervalSince(start)
        context.insert(workout)

        try? context.save()

        currentWorkout = nil
        selectedExercises = []
        startTime = nil
        isWorkoutInProgress = false
    }

    func cancelWorkout() {
        currentWorkout = nil
        selectedExercises = []
        startTime = nil
        isWorkoutInProgress = false
    }

    private func checkAndUpdatePR(exerciseName: String, weight: Double, reps: Int, context: ModelContext) {
        let descriptor = FetchDescriptor<PersonalRecord>(
            predicate: #Predicate { $0.exerciseName == exerciseName }
        )

        guard let existingPR = try? context.fetch(descriptor).first else {
            let newPR = PersonalRecord(exerciseName: exerciseName, maxWeight: weight, maxReps: reps)
            context.insert(newPR)
            return
        }

        if weight > existingPR.maxWeight {
            existingPR.maxWeight = weight
            existingPR.maxReps = reps
            existingPR.achievedDate = Date()
        }
    }

    func getSetsForExercise(_ exerciseName: String) -> [WorkoutSet] {
        currentWorkout?.sets.filter { $0.exerciseName == exerciseName }.sorted { $0.order < $1.order } ?? []
    }
}
