//
//  HomeView.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/14/24.
//

import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        TabView {
            MainWeatherView(viewModel: .init())
                .tabItem {
                    Image(systemName: "cloud.sun.rain.fill")
                }
                .tag(0)
            ChartView(viewModel: .init())
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                }
                .tag(1)
        }
    }
}
