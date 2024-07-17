//
//  MainWeatherView+.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 2024/07/15.
//

import Foundation
import SwiftUI
import Lottie

extension MainWeatherView {
    var HourlyWeatherView: some View {
        VStack {
            Text("Hourly Rain Forecast")
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(viewModel.hourlyForecastModels, id: \.self) { hourlyForecastModel in
                        VStack {
                            HourlyCardView(
                                time: hourlyForecastModel.date.extractComponent(.hourMinute),
                                iconName: hourlyForecastModel.weather.jsonName,
                                feelsLikeTemperature: hourlyForecastModel.feelsLikeTemperature.toTemperature(),
                                actualTemperature: hourlyForecastModel.actualTemperature.toTemperature(),
                                humidity: hourlyForecastModel.humidity.toPercentage() ?? "",
                                precipitaionChance: hourlyForecastModel.precipitationChance.toPercentage() ?? ""
                            )
                        }
                    }
                }
            }
        }
    }
    
    private struct HourlyCardView: View {
        let time: String
        let iconName: String
        let feelsLikeTemperature: String
        let actualTemperature: String
        let humidity: String
        let precipitaionChance: String
        @State var isFlip = false
        
        var body: some View {
            VStack {
                FlipCardView(
                    frontView: FrontHourlyCardView(time: time, iconName: iconName, precipitaionChance: precipitaionChance),
                    backView: BackHourlyCardView(time: time, actualTemperature: feelsLikeTemperature, feelsLikeTemperature: feelsLikeTemperature, humidity: humidity),
                    isFlip: $isFlip
                )
            }
        }
    }
    
    private struct FrontHourlyCardView: View {
        let time: String
        let iconName: String
        let precipitaionChance: String
        
        var body: some View {
            VStack(spacing: 0) {
                Text("\(time)")
                LottieView(animation: .named(iconName))
                    .looping()
                    .frame(height: 40)
                HStack {
                    Image(systemName: "umbrella.percent")
                    Text("\(precipitaionChance)")
                        .font(.system(size: 14))
                }
            }
        }
    }

    private struct BackHourlyCardView: View {
        let time: String
        let actualTemperature: String
        let feelsLikeTemperature: String
        let humidity: String
        
        var body: some View {
            VStack {
                Text("\(time)")
                HStack {
                    Image(systemName: "thermometer.medium")
                    Text("\(actualTemperature)")
                        .font(.system(size: 14))
                }
                HStack {
                    if #available(iOS 17.0, *) {
                        Image(systemName: "thermometer.variable.and.figure")
                    } else {
                        Image(systemName: "medical.thermometer")
                    }
                    Text("\(feelsLikeTemperature)")
                        .font(.system(size: 14))
                }
                HStack {
                    Image(systemName: "humidity")
                    Text("\(humidity)")
                        .font(.system(size: 14))
                }
            }
        }
    }
}
