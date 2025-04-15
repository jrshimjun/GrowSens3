//
//  CameraView.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var lightSensorManager = LightSensorManager()

    var body: some View {
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
            .padding(.vertical, 8)
            .background(Color.white)

            // Title and subtitle
            VStack(alignment: .leading, spacing: 6) {
                Text("Light Measurement")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("Analyze your plant’s lighting conditions in real time.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 40)

            // Graph and Values
            VStack(spacing: 20) {
                ZStack {
                    // Glow if 100%
                    if lightSensorManager.normalizedBrightness >= 1.0 {
                        Circle()
                            .trim(from: 0.0, to: 1.0)
                            .stroke(Color("DarkGreen").opacity(0.6), lineWidth: 20)
                            .blur(radius: 10)
                            .rotationEffect(.degrees(-90))
                            .scaleEffect(1.1)
                            .animation(.easeOut, value: lightSensorManager.normalizedBrightness)
                    }

                    // Background circle
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 14)

                    // Progress circle
                    Circle()
                        .trim(from: 0.0, to: CGFloat(lightSensorManager.normalizedBrightness))
                        .stroke(Color("DarkGreen"), style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut, value: lightSensorManager.normalizedBrightness)

                    // Brightness Text
                    Text("\(lightSensorManager.brightness, specifier: "%.2f")")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(Color("DarkGreen"))
                }
                .frame(width: 240, height: 240)

                Image("sun")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .padding(.top, -12)

                Text("Light levels are just right!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.white)
    }
}



