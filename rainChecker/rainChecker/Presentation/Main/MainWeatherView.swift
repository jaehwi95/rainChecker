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
            ScrollView {
                VStack {
                    HStack {
                        Image(systemName: "location.circle")
                        Text("\(viewModel.currentLocationString)")
                    }
                    VStack {
                        Text("33%")
                            .font(.acmeRegular80)
                        Text("Chance of Rain")
                            .font(.acmeRegular28)
                            .padding(.leading, 40)
                    }
                    LottieView(animation: .named("clear-day"))
                        .looping()
                    Text("Today's precipitation overview")
                    HStack {
                        ForEach(0..<3) { value in
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }.fullWidth()
                    Text("\(Date.now.formatted(date: .abbreviated, time: .shortened))")
                    
                    Text("7-Day Forecast")
                    List {
                        ForEach(0..<7) { value in
                            Text("\(value)")
                        }
                    }
                    Text("\(viewModel.currentWeatherModel.humidity)")
                    Button {
                        Task {
                            await viewModel.getCurrentLocation()
                        }
                    } label: {
                        Text("get location")
                    }

                    Text("\(viewModel.currentWeatherModel.isRaining ? "Raining!" : "Not Raining!")")
                }.padding(.horizontal, 20)
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
