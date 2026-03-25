//
//  ExerciseCard.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI

struct ExerciseCard: View {
    let exerciseName: String
    let sets: [WorkoutSet]
    let onAddSet: (Int, Double) -> Void

    @State private var reps: String = ""
    @State private var weight: String = ""
    @State private var showRestTimer = false
    @State private var restTimerViewModel = RestTimerViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(exerciseName)
                .font(.headline)

            if !sets.isEmpty {
                VStack(spacing: 8) {
                    ForEach(Array(sets.enumerated()), id: \.element.id) { index, set in
                        HStack {
                            Text("Set \(index + 1)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(width: 50, alignment: .leading)

                            Spacer()

                            Text("\(set.reps) reps")
                                .font(.subheadline)
                                .frame(width: 60)

                            Text("\(Int(set.weight)) lbs")
                                .font(.subheadline)
                                .frame(width: 60)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            HStack(spacing: 12) {
                TextField("Reps", text: $reps)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)

                TextField("Weight", text: $weight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)

                Button(action: addSet) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .disabled(reps.isEmpty || weight.isEmpty)

                Spacer()

                Button(action: {
                    showRestTimer = true
                    restTimerViewModel.startTimer(seconds: 90)
                }) {
                    Image(systemName: "timer")
                        .font(.title2)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .sheet(isPresented: $showRestTimer) {
            RestTimerView(viewModel: restTimerViewModel, isPresented: $showRestTimer)
        }
    }

    private func addSet() {
        guard let repsInt = Int(reps),
              let weightDouble = Double(weight) else { return }

        onAddSet(repsInt, weightDouble)

        reps = ""
        weight = ""
    }
}

#Preview {
    ExerciseCard(
        exerciseName: "Bench Press",
        sets: [],
        onAddSet: { _, _ in }
    )
    .padding()
}
