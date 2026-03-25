//
//  AddCustomExerciseView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI

struct AddCustomExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var viewModel: ExerciseLibraryViewModel
    @State private var exerciseName = ""
    @State private var selectedCategory: ExerciseCategory = .chest

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise Details") {
                    TextField("Exercise Name", text: $exerciseName)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ExerciseCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
            }
            .navigationTitle("Add Custom Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        viewModel.addCustomExercise(
                            name: exerciseName,
                            category: selectedCategory,
                            context: modelContext
                        )
                        dismiss()
                    }
                    .disabled(exerciseName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddCustomExerciseView(viewModel: ExerciseLibraryViewModel())
}
