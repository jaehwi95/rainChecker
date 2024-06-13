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
