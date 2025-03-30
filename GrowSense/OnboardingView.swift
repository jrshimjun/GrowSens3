//
//  OnboardingView.swift
//  GrowSense
//
//  Created by Aiko Jones on 3/26/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @State private var currentPage = 0

    let onboardingData: [(String, String, String)] = [
        ("onboarding1", "Accurate Light Measurement", "Uses smartphone sensors to assess light intensity and determine if plant is receiving optimal light."),
        ("onboarding2", "Smart Watering Suggestions", "Integrates air pressure to optimize watering schedules and send alerts when increased evaporation rates may require more frequent watering"),
        ("onboarding3", "Plant Health Tracking", "Logs historical light and watering patterns to analyze trends. Visual reports help users adjust plant care routines based on real data")
    ]

    var body: some View {
        VStack(spacing: 24) {
            // Paged content
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    OnboardingPage(
                        imageName: onboardingData[index].0,
                        title: onboardingData[index].1,
                        subtitle: onboardingData[index].2
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 580)

            // Next button
            Button(action: {
                if currentPage == onboardingData.count - 1 {
                    hasSeenOnboarding = true
                } else {
                    withAnimation {
                        currentPage += 1
                    }
                }
            }) {
                Text("Next")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("DarkGreen"))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }

            // Page indicator dots BELOW the button
            HStack(spacing: 8) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(currentPage == index ? Color("DarkGreen") : Color.gray.opacity(0.4))
                }
            }
            .padding(.bottom, 30)
        }
    }
}












