//
//  PlantViewModel.swift
//  GrowSense
//
//  Created by Aiko Jones on 3/26/25.
//

import Foundation
import FirebaseFirestore

struct Plant: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var imageName: String
}

class PlantViewModel: ObservableObject {
    @Published var myPlants: [Plant] = []
    private var db = Firestore.firestore()

    // Fetches the user's plants from 'userPlants' collection
    func fetchUserPlants() {
        db.collection("userPlants").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user plants: \(error.localizedDescription)")
                return
            }
            self.myPlants = snapshot?.documents.compactMap { doc in
                try? doc.data(as: Plant.self)
            } ?? []
        }
    }

    // Adds a plant by name by looking it up from the global 'plants' collection
    func addPlantByName(_ name: String) {
        db.collection("plants").whereField("name", isEqualTo: name).getDocuments { snapshot, error in
            if let error = error {
                print("Error finding plant: \(error.localizedDescription)")
                return
            }
            guard let doc = snapshot?.documents.first else {
                print("Plant not found in database")
                return
            }

            let plantData = doc.data()
            let imageName = plantData["imageName"] as? String ?? "defaultPlant"

            self.db.collection("userPlants").addDocument(data: [
                "name": name,
                "imageName": imageName
            ]) { err in
                if let err = err {
                    print("Error adding to userPlants: \(err.localizedDescription)")
                } else {
                    print("Successfully added to userPlants")
                    self.fetchUserPlants()
                }
            }
        }
    }
}
