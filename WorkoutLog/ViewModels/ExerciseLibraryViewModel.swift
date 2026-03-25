//
//  ExerciseLibraryViewModel.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import Foundation
import SwiftData

@Observable
final class ExerciseLibraryViewModel {
    var searchText = ""
    var selectedCategory: ExerciseCategory?

    let defaultExercises: [Exercise] = [
        // Chest
        Exercise(name: "Bench Press", category: .chest),
        Exercise(name: "Incline Bench Press", category: .chest),
        Exercise(name: "Dumbbell Press", category: .chest),
        Exercise(name: "Push-ups", category: .chest),
        Exercise(name: "Cable Flyes", category: .chest),

        // Back
        Exercise(name: "Pull-ups", category: .back),
        Exercise(name: "Deadlift", category: .back),
        Exercise(name: "Barbell Row", category: .back),
        Exercise(name: "Lat Pulldown", category: .back),
        Exercise(name: "Seated Cable Row", category: .back),

        // Legs
        Exercise(name: "Squat", category: .legs),
        Exercise(name: "Leg Press", category: .legs),
        Exercise(name: "Romanian Deadlift", category: .legs),
        Exercise(name: "Leg Curl", category: .legs),
        Exercise(name: "Leg Extension", category: .legs),
        Exercise(name: "Calf Raise", category: .legs),

        // Shoulders
        Exercise(name: "Overhead Press", category: .shoulders),
        Exercise(name: "Lateral Raise", category: .shoulders),
        Exercise(name: "Front Raise", category: .shoulders),
        Exercise(name: "Rear Delt Flyes", category: .shoulders),
        Exercise(name: "Arnold Press", category: .shoulders),

        // Arms
        Exercise(name: "Bicep Curl", category: .arms),
        Exercise(name: "Hammer Curl", category: .arms),
        Exercise(name: "Tricep Extension", category: .arms),
        Exercise(name: "Skull Crushers", category: .arms),
        Exercise(name: "Close-Grip Bench Press", category: .arms),

        // Core
        Exercise(name: "Plank", category: .core),
        Exercise(name: "Crunches", category: .core),
        Exercise(name: "Russian Twists", category: .core),
        Exercise(name: "Leg Raises", category: .core),
        Exercise(name: "Ab Wheel", category: .core),

        // Cardio
        Exercise(name: "Running", category: .cardio),
        Exercise(name: "Cycling", category: .cardio),
        Exercise(name: "Rowing", category: .cardio),
        Exercise(name: "Jump Rope", category: .cardio),
        Exercise(name: "Stair Climber", category: .cardio)
    ]

    func initializeDefaultExercises(context: ModelContext) {
        let descriptor = FetchDescriptor<Exercise>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0

        if existingCount == 0 {
            for exercise in defaultExercises {
                context.insert(exercise)
            }
            try? context.save()
        }
    }

    func addCustomExercise(name: String, category: ExerciseCategory, context: ModelContext) {
        let exercise = Exercise(name: name, category: category, isCustom: true)
        context.insert(exercise)
        try? context.save()
    }

    func filteredExercises(_ exercises: [Exercise]) -> [Exercise] {
        var filtered = exercises

        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        return filtered.sorted { $0.name < $1.name }
    }
}
