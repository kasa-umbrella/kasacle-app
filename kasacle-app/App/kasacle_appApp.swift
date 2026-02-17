//
//  kasacle_appApp.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI
import SwiftData

@main
struct kasacle_appApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: WorkoutRecord.self)
    }
}
