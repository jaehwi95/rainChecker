//
//  MainWeatherView.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/12/24.
//

import SwiftUI
import Combine
import Lottie
import MapKit

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
                VStack(spacing: 40) {
                    CurrentLocationView
                    RainPercentage
                    TodayWeather
                    HourlyWeatherView
                    WeeklyWeatherView
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20))
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
        .onChange(of: viewModel.authorizationStatus) { _, newValue in
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

extension MainWeatherView {
    @ViewBuilder
    private var CurrentLocationView: some View {
        if viewModel.authorizationStatus.isAuthorized {
            HStack {
                Image(systemName: "location.circle")
                Text("\(viewModel.currentLocationString)")
            }
        } else {
            if viewModel.updatedLocation != nil {
                HStack {
                    Image(systemName: "location.circle")
                    Text("\(viewModel.currentLocationString)")
                }
            } else {
                VStack {
                    Text("Location Service is currently not set")
                    HStack(spacing: 10) {
                        Button(
                            action: {
                                Task {
                                    await viewModel.openSettings()
                                }
                            },
                            label: {
                                Text("Click Here")
                                    .padding(4)
                                    .foregroundColor(.black)
                                    .background(
                                        RoundedRectangle(
                                            cornerRadius: 10,
                                            style: .continuous
                                        )
                                        .fill(.pink.opacity(0.2))
                                    )
                            }
                        )
                        Text(" to set location service or ")
                        Button(
                            action: {
                                viewModel.isShowLocationSettingSheet = true
                            },
                            label: {
                                Text("Manually set location")
                                    .padding(4)
                                    .foregroundColor(.black)
                                    .background(
                                        RoundedRectangle(
                                            cornerRadius: 10,
                                            style: .continuous
                                        )
                                        .fill(.pink.opacity(0.2))
                                    )
                            }
                        )
                    }
                }
            }
            
        }
    }
    
    private var RainPercentage: some View {
        VStack {
            Text("\(viewModel.todayRainPercentage.toPercentage() ?? "")")
                .font(.acmeRegular80)
            HStack {
                Spacer()
                    .fullWidth()
                Text("Chance of Rain")
                    .font(.acmeRegular28)
                    .fullWidth()
            }
        }
    }
    
    private var TodayWeather: some View {
        VStack(spacing: 20) {
            LottieView(animation: .named(viewModel.currentWeatherModel.weather.jsonName))
                .looping()
                .frame(height: 160)
            HStack(spacing: 40) {
                Text("\(viewModel.currentWeatherModel.date.extractComponent(.weekday))")
                Divider().background(Color.black.opacity(0.5))
                Text("\(viewModel.currentWeatherModel.date.extractComponent(.monthDay))")
            }
            Text("\(viewModel.currentWeatherModel.actualTemperature.toTemperature())")
                .font(.acmeRegular40)
            Text("\(viewModel.currentWeatherModel.weather.description)")
            Divider().background(Color.black.opacity(0.5))
            
            
        }
    }
    
    private var WeeklyWeatherView: some View {
        VStack {
            Text("7-Day Rain Forecast")
            ForEach(viewModel.weeklyForecastModels, id: \.self) { weeklyForecastModel in
                HStack {
                    Text("\(weeklyForecastModel.date.extractComponent(.weekday))")
                    LottieView(animation: .named(weeklyForecastModel.weather.jsonName))
                        .looping()
                        .frame(height: 20)
                    HStack {
                        Image(systemName: "umbrella.percent")
                        Text("\(weeklyForecastModel.precipitationChance.toPercentage() ?? "")")
                    }
                }
                if weeklyForecastModel != viewModel.weeklyForecastModels.last {
                    Divider().background(Color.black.opacity(0.5))
                }
            }
        }
    }
}

extension MainWeatherView {
    private var LocationSettingSheetView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.mint, .green]),
                startPoint: .topTrailing,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Input City and Country to set location")
                TextField("City", text: $viewModel.inputCity)
                    .padding(4)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .fill(.white.opacity(0.2))
                    )
                TextField("Country", text: $viewModel.inputCountry)
                    .padding(4)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .fill(.white.opacity(0.2))
                    )
                if viewModel.isShowCityCountryError {
                    Text("Invalid City or Country")
                }
                Button("Set Location") {
                    Task {
                        await viewModel.updateCurrentLocation()
                        await withTaskGroup(of: Void.self) { group in
                            group.addTask { await viewModel.getCurrentWeather(location: viewModel.updatedLocation ?? .seoul) }
                            group.addTask { await viewModel.getTodayWeatherForecast(location: viewModel.updatedLocation ?? .seoul) }
                            group.addTask { await viewModel.getWeekWeatherForecast(location: viewModel.updatedLocation ?? .seoul) }
                            await group.waitForAll()
                        }
                    }
                }
            }.padding(.horizontal, 20)
        }
    }
}
