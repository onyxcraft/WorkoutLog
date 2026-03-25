//
//  ContentView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @State private var workoutViewModel = WorkoutViewModel()
    @State private var exerciseLibraryViewModel = ExerciseLibraryViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            WorkoutView(viewModel: workoutViewModel)
                .tabItem {
                    Label("Workout", systemImage: "figure.strengthtraining.traditional")
                }
                .tag(0)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "calendar")
                }
                .tag(1)

            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)

            TemplatesView()
                .tabItem {
                    Label("Templates", systemImage: "list.bullet.clipboard")
                }
                .tag(3)
        }
        .onAppear {
            exerciseLibraryViewModel.initializeDefaultExercises(context: modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Exercise.self, Workout.self, WorkoutTemplate.self, PersonalRecord.self], inMemory: true)
}
