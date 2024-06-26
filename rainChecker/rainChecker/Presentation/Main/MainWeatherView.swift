//
//  MainWeatherView.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/12/24.
//

import SwiftUI
import Combine
import Lottie

struct MainWeatherView: View {
    @ObservedObject var viewModel: MainWeatherViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .cyan]),
                startPoint: .topTrailing,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: "location.circle")
                    Text("Seoul")
                }
                LottieView(animation: .named("clear-day"))
                    .looping()
                Text("\(Date.now.formatted(date: .abbreviated, time: .shortened))")
                
                Text("\(viewModel.currentWeatherModel.actualTemperature)")
                Text("\(viewModel.currentWeatherModel.humidity)")
                Button {
                    viewModel.requestLocationAuthorization()
                } label: {
                    Text("get locaiton")
                }

                Text("\(viewModel.currentWeatherModel.isRaining ? "Raining!" : "Not Raining!")")
            }
        }
        .onAppear {
            Task {
                await viewModel.getCurrentWeather()
            }
        }
    }
}

enum rainStatus: Double {
    case raining = 100
    case willRain
    case mayRain = 50
    case mightRain = 30
    case couldRain = 10
    case notRain = 0.0
}
