//
//  kasacle_appApp.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftData
import SwiftUI

@main
struct kasacle_appApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [
            WorkoutRecord.self, WorkoutSession.self, WorkoutSet.self, CustomExercise.self,
            LlmMessageRecord.self,
        ])
    }
}
