//
//  GrowSense.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//

import SwiftUI

enum Tab {
    case home, light, camera, reminders, settings
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            viewForSelectedTab()
                .padding(.bottom, 90)

            CustomTabBarView(selectedTab: $selectedTab)
        }
    }

    @ViewBuilder
    private func viewForSelectedTab() -> some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .light:
            CameraView()
        case .camera:
            PlantScanView()
        case .reminders:
            RemindersView()
        case .settings:
            NavigationView {
                SettingsView()
            }
        }
    }

    
    struct CustomTabBarView: View {
        @Binding var selectedTab: Tab
        
        var body: some View {
            HStack {
                tabBarItem(tab: .home, image: "tab_home", selectedImage: "tab_home_selected")
                tabBarItem(tab: .light, image: "tab_light", selectedImage: "tab_light_selected")
                
                Button {
                    selectedTab = .camera
                } label: {
                    Image(selectedTab == .camera ? "tab_camera_selected" : "tab_camera")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .padding(.horizontal, 12)
                }
                
                tabBarItem(tab: .reminders, image: "tab_reminders", selectedImage: "tab_reminders_selected")
                tabBarItem(tab: .settings, image: "tab_settings", selectedImage: "tab_settings_selected")
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 25)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(radius: 5)
        }
        
        private func tabBarItem(tab: Tab, image: String, selectedImage: String) -> some View {
            Button {
                selectedTab = tab
            } label: {
                Image(selectedTab == tab ? selectedImage : image)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .padding(.horizontal, 12)
            }
        }
    }
    
    
    struct MainTabView_Previews: PreviewProvider {
        static var previews: some View {
            MainTabView()
        }
    }
}
