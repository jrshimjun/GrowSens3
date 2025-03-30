//
//  RemindersView.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//

import SwiftUI

struct RemindersView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("No upcoming reminders yet.")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
                
                Button(action: {
                    print("Schedule a new reminder tapped!")
                }) {
                    Text("Schedule a Reminder")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Upcoming Reminders")
        }
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CameraView()
        }

    }
}
