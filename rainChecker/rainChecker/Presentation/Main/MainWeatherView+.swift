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
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(viewModel.hourlyForecastModels, id: \.self) { hourlyForecastModel in
                    VStack {
                        HourlyCardView(
                            time: hourlyForecastModel.date.extractComponent(.hourMinute),
                            iconName: hourlyForecastModel.weather.jsonName,
                            feelsLikeTemperature: String(hourlyForecastModel.feelsLikeTemperature),
                            actualTemperature: String(hourlyForecastModel.actualTemperature),
                            humidity: String(hourlyForecastModel.humidity),
                            precipitaionChance: hourlyForecastModel.precipitationChance.toPercentage() ?? ""
                        )
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
                    frontView: FrontHourlyCardView(time: time, iconName: iconName, actualTemperature: feelsLikeTemperature),
                    backView: BackHourlyCardView(time: time, feelsLikeTemperature: feelsLikeTemperature, humidity: humidity, precipitaionChance: precipitaionChance),
                    isFlip: $isFlip
                )
            }
        }
    }
    
    private struct FrontHourlyCardView: View {
        let time: String
        let iconName: String
        let actualTemperature: String
        
        var body: some View {
            VStack(spacing: 0) {
                Text("\(time)")
                LottieView(animation: .named(iconName))
                    .looping()
                    .frame(height: 40)
                HStack {
                    Image(systemName: "thermometer.medium")
                    Text("\(actualTemperature)")
                }
            }
        }
    }

    private struct BackHourlyCardView: View {
        let time: String
        let feelsLikeTemperature: String
        let humidity: String
        let precipitaionChance: String
        
        var body: some View {
            VStack(spacing: 0) {
                Text("\(time)")
                HStack {
                    Image(systemName: "thermometer.variable.and.figure")
                    Text("\(feelsLikeTemperature)")
                        .font(.system(size: 10))
                }
                HStack {
                    Image(systemName: "humidity")
                    Text("\(humidity)")
                        .font(.system(size: 10))
                }
                HStack {
                    Image(systemName: "umbrella.percent")
                    Text("\(precipitaionChance)")
                        .font(.system(size: 10))
                }
            }
        }
    }

}
