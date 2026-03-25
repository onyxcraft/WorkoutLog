//
//  PersonalRecord.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import Foundation
import SwiftData

@Model
final class PersonalRecord {
    var id: UUID
    var exerciseName: String
    var maxWeight: Double
    var maxReps: Int
    var achievedDate: Date

    init(exerciseName: String, maxWeight: Double, maxReps: Int, achievedDate: Date = Date()) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.maxWeight = maxWeight
        self.maxReps = maxReps
        self.achievedDate = achievedDate
    }
}
