# WorkoutLog

A simple and powerful workout tracking app for iOS 17+.

## Features

- **Quick Workout Logging**: Log exercises with sets, reps, and weight
- **Exercise Library**: 40+ pre-loaded exercises organized by muscle groups (Chest, Back, Legs, Shoulders, Arms, Core, Cardio)
- **Custom Exercises**: Add your own exercises to the library
- **Workout Templates**: Save and reuse your favorite workout routines
- **Progress Charts**: Visualize your strength progression over time with interactive charts
- **Personal Records**: Automatic PR tracking with trophy badges
- **Calendar View**: See your workout history at a glance
- **Rest Timer**: Built-in rest timer with haptic feedback
- **Workout Summary**: Detailed stats including total volume, sets, reps, and duration
- **Dark Mode**: Full support for iOS dark mode
- **iPad Support**: Optimized for both iPhone and iPad

## Technical Details

- **Platform**: iOS 17.0+
- **Architecture**: MVVM (Model-View-ViewModel)
- **Data Persistence**: SwiftData
- **Charts**: Swift Charts framework
- **UI Framework**: SwiftUI
- **Dependencies**: None (100% native Swift)

## App Store Information

- **Bundle ID**: com.lopodragon.workoutlog
- **Price**: $3.99 USD (one-time purchase)
- **Category**: Health & Fitness

## Project Structure

```
WorkoutLog/
├── Models/              # SwiftData models
│   ├── Exercise.swift
│   ├── Workout.swift
│   ├── WorkoutSet.swift
│   ├── WorkoutTemplate.swift
│   └── PersonalRecord.swift
├── ViewModels/          # MVVM ViewModels
│   ├── WorkoutViewModel.swift
│   ├── ExerciseLibraryViewModel.swift
│   └── RestTimerViewModel.swift
├── Views/               # SwiftUI Views
│   ├── ContentView.swift
│   ├── WorkoutView.swift
│   ├── HistoryView.swift
│   ├── ProgressView.swift
│   ├── TemplatesView.swift
│   └── ...
└── Assets.xcassets/     # App assets
```

## Building

1. Open `WorkoutLog.xcodeproj` in Xcode 15.0 or later
2. Select your development team in the project settings
3. Build and run on a device or simulator running iOS 17.0+

## License

MIT License - see LICENSE file for details

## Version

1.0.0 - Initial release
