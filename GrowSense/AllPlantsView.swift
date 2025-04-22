import SwiftUI

struct AllPlantsView: View {
    @ObservedObject var viewModel: PlantViewModel
    @State private var selectedPlant: Plant? = nil
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.myPlants) { plant in
                    MiniPlantCard(plant: plant)
                        .onTapGesture {
                            selectedPlant = plant
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedPlant != nil {
                        Button(role: .destructive) {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }

            .alert("Delete Plant?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let plantToDelete = selectedPlant {
                        viewModel.deletePlant(plantToDelete)
                    }
                    selectedPlant = nil
                }

                Button("Cancel", role: .cancel) {
                    selectedPlant = nil
                }
            } message: {
                Text("Are you sure you want to delete \(selectedPlant?.name ?? "this plant")?")
            }

            .navigationTitle("My Plants")
        }
    }
}
