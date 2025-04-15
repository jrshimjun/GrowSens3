//
//  AllPlantsView.swift
//  GrowSense
//
//  Created by Aiko Jones on 4/14/25.
//

import SwiftUI

struct AllPlantsView: View {
    var plants: [Plant]

    // Define grid layout
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(plants) { plant in
                    MiniPlantCard(plant: plant)
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .navigationTitle("Plant Database")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
    }
}

