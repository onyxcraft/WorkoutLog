//
//  TemplatesView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI
import SwiftData

struct TemplatesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutTemplate.createdAt, order: .reverse) private var templates: [WorkoutTemplate]
    @State private var showAddTemplate = false

    var body: some View {
        NavigationStack {
            Group {
                if templates.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(templates) { template in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(template.name)
                                    .font(.headline)

                                Text("\(template.exerciseNames.count) exercises")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                ForEach(template.exerciseNames, id: \.self) { exerciseName in
                                    Text("• \(exerciseName)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteTemplates)
                    }
                }
            }
            .navigationTitle("Templates")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddTemplate = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTemplate) {
                AddTemplateView()
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("No Templates")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Create templates to quickly start workouts")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
    }

    private func deleteTemplates(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(templates[index])
        }
    }
}

#Preview {
    TemplatesView()
        .modelContainer(for: [WorkoutTemplate.self], inMemory: true)
}
