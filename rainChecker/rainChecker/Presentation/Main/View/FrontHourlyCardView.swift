//
//  FrontHourlyCardView.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 9/21/24.
//

import SwiftUI
import Lottie

struct FrontHourlyCardView: View {
    private let time: String
    private let iconName: String
    private let precipitationChance: Double
    
    public init(
        time: String,
        iconName: String,
        precipitationChance: Double
    ) {
        self.time = time
        self.iconName = iconName
        self.precipitationChance = precipitationChance
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("\(time)")
            LottieView(animation: .named(iconName))
                .looping()
                .frame(height: 40)
            HStack(spacing: 10) {
                Image(systemName: "umbrella.percent")
                Text("\(precipitationChance.toPercentage())")
                    .font(.system(size: 14))
            }
        }
    }
}

#Preview {
    FrontHourlyCardView(
        time: "16:00",
        iconName: "rain",
        precipitationChance: 0.13
    )
}
