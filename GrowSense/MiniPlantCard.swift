//
//  MiniPlantCard.swift
//  GrowSense
//
//  Created by Aiko Jones on 3/26/25.
//

import SwiftUI

struct MiniPlantCard: View {
    var name: String
    var imageName: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            Text(name).font(.subheadline).bold()
        }
        .frame(width: 150, height: 180)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
