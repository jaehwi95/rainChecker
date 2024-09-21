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
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .cyan]),
                startPoint: .topTrailing,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 40) {
                    CurrentLocationView
                    RainPercentageView
                    TodayWeatherView
                    Divider().background(Color.black.opacity(0.5))
                    HourlyForecastView
                    WeeklyWeatherView
                    WeatherAttributionView
                }
                .padding(
                    EdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)
                )
            }
        }
        .sheet(
            isPresented: $viewModel.isShowLocationSettingSheet,
            content: {
                LocationSettingSheetView
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium])
            }
        )
        .apply {
            if #available(iOS 17.0, *) {
                $0.onChange(of: viewModel.authorizationStatus) { _, newValue in
                    Task {
                        await viewModel.getCurrentLocation()
                        await withTaskGroup(of: Void.self) { group in
                            group.addTask { await viewModel.getCurrentWeather(location: viewModel.currentLocation) }
                            group.addTask { await viewModel.getTodayWeatherForecast(location: viewModel.currentLocation) }
                            group.addTask { await viewModel.getWeekWeatherForecast(location: viewModel.currentLocation) }
                            await group.waitForAll()
                        }
                    }
                }
            } else {
                $0.onChange(of: viewModel.authorizationStatus) { value in
                    Task {
                        await viewModel.getCurrentLocation()
                        await withTaskGroup(of: Void.self) { group in
                            group.addTask { await viewModel.getCurrentWeather(location: viewModel.currentLocation) }
                            group.addTask { await viewModel.getTodayWeatherForecast(location: viewModel.currentLocation) }
                            group.addTask { await viewModel.getWeekWeatherForecast(location: viewModel.currentLocation) }
                            await group.waitForAll()
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getWeatherAttribution()
            }
        }
    }
}
