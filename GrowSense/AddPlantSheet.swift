//
//  AddPlantSheet.swift
//  GrowSense
//
//  Created by Aiko Jones on 3/26/25.
//

import SwiftUI

struct AddPlantSheet: View {
    @Binding var newPlantName: String
    @Binding var isLoading: Bool
    @ObservedObject var plantVM: PlantViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Add a New Plant").font(.title2).bold()

            TextField("Enter plant name", text: $newPlantName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                if !newPlantName.isEmpty {
                    plantVM.addPlantByName(newPlantName)
                    newPlantName = ""
                    isLoading = false
                    dismiss()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("DarkGreen"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)

            Spacer()
        }
        .padding()
    }
}
