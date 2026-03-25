//
//  WorkoutSet.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import Foundation
import SwiftData

@Model
final class WorkoutSet {
    var id: UUID
    var reps: Int
    var weight: Double
    var exerciseName: String
    var order: Int
    var createdAt: Date

    init(reps: Int, weight: Double, exerciseName: String, order: Int) {
        self.id = UUID()
        self.reps = reps
        self.weight = weight
        self.exerciseName = exerciseName
        self.order = order
        self.createdAt = Date()
    }
}
