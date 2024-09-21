//
//  MainWeatherView+Extension.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 2024/07/15.
//

import Foundation
import SwiftUI
import Lottie

extension MainWeatherView {
    @ViewBuilder
    var CurrentLocationView: some View {
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
    
    var RainPercentageView: some View {
        VStack {
            Text("\(viewModel.todayRainPercentage.toPercentage())")
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
    
    var TodayWeatherView: some View {
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
        }
    }
    
    var HourlyForecastView: some View {
        VStack {
            Text("Hourly Rain Forecast")
            ScrollViewReader { scrollViewProxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(viewModel.hourlyForecastModels, id: \.id) { hourlyForecastModel in
                            HourlyCardView(
                                time: hourlyForecastModel.date.extractComponent(.hourMinute),
                                iconName: hourlyForecastModel.weather.jsonName,
                                feelsLikeTemperature: hourlyForecastModel.feelsLikeTemperature,
                                actualTemperature: hourlyForecastModel.actualTemperature,
                                humidity: hourlyForecastModel.humidity,
                                precipitaionChance: hourlyForecastModel.precipitationChance
                            )
                            .padding(.vertical, 20)
                        }
                    }
                }
                .onChange(of: viewModel.hourlyForecastModels) { _ in
                    // When receiveing hourly forcasts, move the scroll to current - 1 hour forecast
                    withAnimation {
                        let currentHour = Calendar.current.component(.hour, from: Date())
                        if viewModel.hourlyForecastModels.count >= currentHour {
                            let currentHourForecastId = viewModel.hourlyForecastModels[currentHour].id
                            scrollViewProxy.scrollTo(currentHourForecastId, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    var WeeklyWeatherView: some View {
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
                        Text("\(weeklyForecastModel.precipitationChance.toPercentage())")
                    }
                }
                if weeklyForecastModel != viewModel.weeklyForecastModels.last {
                    Divider().background(Color.black.opacity(0.5))
                }
            }
        }
    }
    
    var WeatherAttributionView: some View {
        VStack {
            Text("Powered by")
            AsyncImage(url: viewModel.weatherAttributionModel.lightLogoTextURL) { image in
                image
            } placeholder: {
                ProgressView()
            }
            .padding(.horizontal, 40)
            if viewModel.weatherAttributionModel.legalAttributionText.isEmpty {
                Button("Show Legal Attribution") {
                    openURL(viewModel.weatherAttributionModel.legalPageURL)
                }
            } else {
                DisclosureGroup(
                    content: {
                        VStack {
                            Text("\(viewModel.weatherAttributionModel.legalAttributionText)")
                        }
                    },
                    label: {
                        Text("Show Legal Attribution")
                    }
                )
                .tint(.black)
                .padding(.horizontal, 40)
            }
        }
        .padding(.top, 40)
    }
}

/// View for Sheet
extension MainWeatherView {
    var LocationSettingSheetView: some View {
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
