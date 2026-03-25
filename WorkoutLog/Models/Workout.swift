//
//  Workout.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import Foundation
import SwiftData

@Model
final class Workout {
    var id: UUID
    var date: Date
    var duration: TimeInterval
    var notes: String

    @Relationship(deleteRule: .cascade)
    var sets: [WorkoutSet]

    init(date: Date = Date(), duration: TimeInterval = 0, notes: String = "") {
        self.id = UUID()
        self.date = date
        self.duration = duration
        self.notes = notes
        self.sets = []
    }

    var totalVolume: Double {
        sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
    }

    var totalSets: Int {
        sets.count
    }

    var totalReps: Int {
        sets.reduce(0) { $0 + $1.reps }
    }

    var exerciseNames: [String] {
        Array(Set(sets.map { $0.exerciseName })).sorted()
    }
}
