//
//  GrowSense.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "leaf")
                }
            
            CameraView()
                .tabItem {
                    Label("Light Sensor", systemImage: "camera")
                }
            
            RemindersView()
                .tabItem {
                    Label("Reminders", systemImage: "calendar")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
