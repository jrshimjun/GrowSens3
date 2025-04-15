//
//  MiniPlantCard.swift
//  GrowSense
//
//  Created by Aiko Jones on 3/26/25.
//

import SwiftUI

struct MiniPlantCard: View {
    var plant: Plant

    var body: some View {
        NavigationLink(destination: PlantDetailView(plant: plant)) {
            VStack {
                Image(plant.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                Text(plant.name)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
            }
            .frame(width: UIScreen.main.bounds.width / 2 - 32, height: 180)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
        }
    }
}


