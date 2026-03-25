//
//  RestTimerViewModel.swift
//  WorkoutLog
//
//  Created on 2026-03-25.
//

import Foundation
import SwiftUI

@Observable
final class RestTimerViewModel {
    var timeRemaining: Int = 0
    var isRunning = false
    var timer: Timer?

    func startTimer(seconds: Int) {
        timeRemaining = seconds
        isRunning = true

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.timeRemaining > 0 {
                self.timeRemaining -= 1

                if self.timeRemaining == 0 {
                    self.triggerHapticFeedback()
                    self.stop()
                }
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        timeRemaining = 0
    }

    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func resume() {
        guard timeRemaining > 0 else { return }
        isRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.timeRemaining > 0 {
                self.timeRemaining -= 1

                if self.timeRemaining == 0 {
                    self.triggerHapticFeedback()
                    self.stop()
                }
            }
        }
    }

    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
