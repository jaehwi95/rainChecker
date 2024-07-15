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
    @StateObject var viewModel: MainWeatherViewModel
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
                        Text("\(viewModel.todayRainPercentage)")
                            .font(.acmeRegular80)
                        HStack {
                            Spacer()
                                .fullWidth()
                            Text("Chance of Rain")
                                .font(.acmeRegular28)
                                .fullWidth()
                        }
                    }
                    VStack {
                        Text("Today's Weather")
                        LottieView(animation: .named(viewModel.currentWeatherModel.weather.jsonName))
                            .looping()
                            .frame(height: 300)
                    }
                    Text("Hourly Forecast")
                    HourlyWeatherView
                    Text("7-Day Forecast")
                    List {
                        ForEach(0..<7) { value in
                            Text("\(value)")
                        }
                    }
                    Text("\(viewModel.currentWeatherModel.isRaining ? "Raining!" : "Not Raining!")")
                }.padding(.horizontal, 20)
            }
        }
        .onChange(of: viewModel.authorizationStatus) { _, newValue in
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask { await viewModel.getCurrentLocation() }
                    group.addTask { await viewModel.getCurrentWeather() }
                    group.addTask { await viewModel.getTodayWeatherForecast() }
                    group.addTask { await viewModel.getWeekWeatherForecast() }
                    await group.waitForAll()
                }
            }
        }
    }
}

extension MainWeatherView {
    private var WeatherIconView: some View {
        VStack{}
    }
    
    private var TodayPrecipitationView: some View {
        VStack {
            Text("Today's precipitation overview")
            HStack {
                ForEach(0..<3) { value in
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                }
            }.fullWidth()
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
