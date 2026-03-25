//
//  Exercise.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import Foundation
import SwiftData

enum ExerciseCategory: String, Codable, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case core = "Core"
    case cardio = "Cardio"
}

@Model
final class Exercise {
    var id: UUID
    var name: String
    var category: ExerciseCategory
    var isCustom: Bool
    var createdAt: Date

    init(name: String, category: ExerciseCategory, isCustom: Bool = false) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.isCustom = isCustom
        self.createdAt = Date()
    }
}
