//
//  OnboardingPageView.swift
//  GrowSense
//
//  Created by Aiko Jones on 3/26/25.
//
import SwiftUI

struct OnboardingPage: View {
    var imageName: String
    var title: String
    var subtitle: String

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 60)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 260)

            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer()
        }
    }
}







