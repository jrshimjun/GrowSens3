//
//  SettingsView.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("App")) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Image(systemName: "bell")
                        Text("Notifications")
                        Spacer()
                        Text("Enabled")
                            .foregroundColor(.green)
                    }
                }

                Section(header: Text("Support")) {
                    NavigationLink(destination: Text("Coming soon")) {
                        Label("Send Feedback", systemImage: "envelope")
                    }

                    NavigationLink(destination: Text("Coming soon")) {
                        Label("About GrowSense", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(InsetGroupedListStyle())
        }
    }
}
