//
//  HomeView.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var plantVM = PlantViewModel()
    @State private var showAddPlantSheet = false
    @State private var newPlantName = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Image(systemName: "leaf.circle")
                        .font(.system(size: 28))
                        .foregroundColor(Color("DarkGreen"))
                    Spacer()
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                    Image("profileIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
                .padding(.horizontal)
                .padding(.vertical, 5)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Welcome + Score
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Hi Noynica!").font(.title2).fontWeight(.bold)
                                Text("Your plants are thriving—let’s keep them happy!")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            ZStack {
                                Circle().stroke(Color.green.opacity(0.3), lineWidth: 5)
                                Circle()
                                    .trim(from: 0, to: 0.75)
                                    .stroke(Color("DarkGreen"), lineWidth: 5)
                                    .rotationEffect(.degrees(-90))
                                VStack {
                                    Image(systemName: "leaf.fill").foregroundColor(.green)
                                    Text("12").font(.footnote).bold()
                                }
                            }
                            .frame(width: 50, height: 50)
                        }
                        .padding(.horizontal)

                        // My Plants Section
                        Text("My Plants")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .padding(.top, 10)

                        if plantVM.myPlants.isEmpty {
                            Text("No plants yet...").foregroundColor(.gray).padding()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(plantVM.myPlants) { plant in
                                        MiniPlantCard(name: plant.name, imageName: plant.imageName)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .frame(height: 200)
                            .padding(.top, 8)
                        }

                        // Add Button
                        Button(action: {
                            withAnimation { isLoading = true }
                            showAddPlantSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill").font(.title2)
                                Text(isLoading ? "Loading..." : "Add New Plant")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("DarkGreen"))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)

                        // Static Plant DB
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Plant Database").font(.headline)
                                Spacer()
                                Text("View all")
                                    .foregroundColor(Color("DarkGreen"))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    MiniPlantCard(name: "Peperomia Houseplant", imageName: "peperomia")
                                    MiniPlantCard(name: "Asplenium Houseplant", imageName: "asplenium")
                                }
                                .padding(.horizontal, 20)
                            }
                            .frame(height: 200)
                        }
                        .padding(.top, 20)

                        Spacer().padding(.bottom, 30)
                    }
                }
            }
        }
        .onAppear { plantVM.fetchUserPlants() }
        .sheet(isPresented: $showAddPlantSheet, onDismiss: { isLoading = false }) {
            AddPlantSheet(newPlantName: $newPlantName, isLoading: $isLoading, plantVM: plantVM)
        }
    }
}





