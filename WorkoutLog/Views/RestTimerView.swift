//
//  RestTimerView.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import SwiftUI

struct RestTimerView: View {
    @Bindable var viewModel: RestTimerViewModel
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 30) {
            Text("Rest Timer")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(viewModel.formattedTime)
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .monospacedDigit()

            HStack(spacing: 20) {
                if viewModel.isRunning {
                    Button(action: {
                        viewModel.pause()
                    }) {
                        Image(systemName: "pause.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }
                } else if viewModel.timeRemaining > 0 {
                    Button(action: {
                        viewModel.resume()
                    }) {
                        Image(systemName: "play.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }

                Button(action: {
                    viewModel.stop()
                    isPresented = false
                }) {
                    Image(systemName: "stop.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }

            if !viewModel.isRunning && viewModel.timeRemaining == 0 {
                VStack(spacing: 16) {
                    Text("Quick Start")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        ForEach([60, 90, 120, 180], id: \.self) { seconds in
                            Button(action: {
                                viewModel.startTimer(seconds: seconds)
                            }) {
                                Text("\(seconds / 60)m")
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .frame(width: 60, height: 40)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}

#Preview {
    RestTimerView(viewModel: RestTimerViewModel(), isPresented: .constant(true))
}
