//
//  AddTemplateView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI
import SwiftData

struct AddTemplateView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise]

    @State private var templateName = ""
    @State private var selectedExercises: [String] = []
    @State private var showExerciseLibrary = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Template Name") {
                    TextField("Enter template name", text: $templateName)
                }

                Section("Exercises") {
                    if selectedExercises.isEmpty {
                        Text("No exercises added")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(selectedExercises, id: \.self) { exerciseName in
                            HStack {
                                Text(exerciseName)
                                Spacer()
                                Button(action: {
                                    selectedExercises.removeAll { $0 == exerciseName }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                    }

                    Button(action: {
                        showExerciseLibrary = true
                    }) {
                        Label("Add Exercise", systemImage: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("New Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveTemplate()
                    }
                    .disabled(templateName.isEmpty || selectedExercises.isEmpty)
                }
            }
            .sheet(isPresented: $showExerciseLibrary) {
                ExerciseLibraryView(onSelectExercise: { exercise in
                    if !selectedExercises.contains(exercise.name) {
                        selectedExercises.append(exercise.name)
                    }
                    showExerciseLibrary = false
                })
            }
        }
    }

    private func saveTemplate() {
        let template = WorkoutTemplate(name: templateName, exerciseNames: selectedExercises)
        modelContext.insert(template)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    AddTemplateView()
        .modelContainer(for: [WorkoutTemplate.self, Exercise.self], inMemory: true)
}
