//
//  GrowSenseApp.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//

import SwiftUI
import Firebase

@main
struct GrowSenseApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    init() {
        FirebaseApp.configure()
        UserDefaults.standard.set(false, forKey: "hasSeenOnboarding") 
    }

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                MainTabView()
                    .environmentObject(PlantViewModel())
            } else {
                OnboardingView()
            }
        }
    }
}




