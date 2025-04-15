//
//  PlantScanView.swift
//  GrowSense
//
//  Created by Jun Shim on 4/14/25.
//


import SwiftUI

struct PlantScanView: View {
    @StateObject private var viewModel = CameraViewModel()
    @EnvironmentObject var plantViewModel: PlantViewModel

    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()

            VStack {
                Spacer()

                if viewModel.isLoading {
                    ProgressView("Identifying...")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                } else if let name = viewModel.capturedPlantName,
                          let confidence = viewModel.confidence {
                    VStack(spacing: 10) {
                        Text("🌿 \(name)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Confidence: \(String(format: "%.1f", confidence * 100))%")
                            .foregroundColor(.white)

                        Button("Add to My Plants") {
                            plantViewModel.addPlantByName(name)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .foregroundColor(.green)
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(16)
                }

                Button(action: {
                    viewModel.captureImage()
                }) {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .padding(.bottom)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}
