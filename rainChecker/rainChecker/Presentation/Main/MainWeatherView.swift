//
//  MainWeatherView.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/12/24.
//

import SwiftUI
import Combine

struct MainWeatherView: View {
    @ObservedObject var viewModel: MainWeatherViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Text("Seoul")
            Text("\(Date.now)")
            Image(systemName: "sun.min")
            Text("\(viewModel.currentWeatherModel.actualTemperature)")
            Text("\(viewModel.currentWeatherModel.humidity)")
            Text("\(viewModel.currentWeatherModel.isRaining ? "Raining!" : "Not Raining!")")
        }
        .onAppear {
            Task {
                await viewModel.getCurrentWeather()
            }
        }
    }
}
