//
//  PlantDetailView.swift
//  GrowSense
//
//  Created by Aiko Jones on 4/14/25.
//

import SwiftUI

struct PlantDetailView: View {
    let plant: Plant

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Image(plant.imageName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .padding()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Scientific Name: \(plant.scientificName)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("💡 Ideal Light Range")
                            .font(.headline)
                        Text("\(plant.minLight) – \(plant.maxLight) lux")
                            .padding(.leading)

                        Text("🪴 About This Plant")
                            .font(.headline)
                            .padding(.top, 8)
                        Text(plant.description)
                            .padding(.leading)

                        Text("💧 Watering: \(plant.waterFrequency)")
                            .padding(.top, 8)
                            .padding(.leading)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(plant.name) // ← Step 3
        .navigationBarTitleDisplayMode(.inline)
    }
}
