//
//  HomeView.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to GrowSense")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: CameraView()) {
                    Text("Go to Light Sensor")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
