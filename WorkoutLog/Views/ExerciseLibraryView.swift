//
//  ExerciseLibraryView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI
import SwiftData

struct ExerciseLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise]

    @State private var viewModel = ExerciseLibraryViewModel()
    @State private var showAddCustomExercise = false

    let onSelectExercise: (Exercise) -> Void

    var body: some View {
        NavigationStack {
            VStack {
                categoryPicker

                List {
                    ForEach(viewModel.filteredExercises(exercises)) { exercise in
                        Button(action: {
                            onSelectExercise(exercise)
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(exercise.name)
                                        .foregroundStyle(.primary)

                                    if exercise.isCustom {
                                        Text("Custom")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                }
                .searchable(text: $viewModel.searchText, prompt: "Search exercises")
            }
            .navigationTitle("Exercise Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddCustomExercise = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddCustomExercise) {
                AddCustomExerciseView(viewModel: viewModel)
            }
        }
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    title: "All",
                    isSelected: viewModel.selectedCategory == nil,
                    action: { viewModel.selectedCategory = nil }
                )

                ForEach(ExerciseCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        isSelected: viewModel.selectedCategory == category,
                        action: { viewModel.selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .clipShape(Capsule())
        }
    }
}

#Preview {
    ExerciseLibraryView(onSelectExercise: { _ in })
        .modelContainer(for: [Exercise.self], inMemory: true)
}
