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
                    VStack {
                        Text("33%").font(.system(size: 80))
                        Text("Chance of Rain")
                            .font(.acmeRegular28)
                            .fontWeight(.bold)
                            .padding(.leading, 40)
                    }
                    LottieView(animation: .named("clear-day"))
                        .looping()
                    HStack {
                        Image(systemName: "location.circle")
                        Text("Seoul, Korea")
                        Text("\(viewModel.currentWeatherModel.actualTemperature)")
                    }
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
                        viewModel.requestLocationAuthorization()
                    } label: {
                        Text("get locaiton")
                    }

                    Text("\(viewModel.currentWeatherModel.isRaining ? "Raining!" : "Not Raining!")")
                }.padding(.horizontal, 20)
            }
        }
        .onAppear {
            for fontFamily in UIFont.familyNames {
                for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                    print(fontName)
                }
            }
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
