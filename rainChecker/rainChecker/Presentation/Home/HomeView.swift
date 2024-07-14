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
                // sets visibility for background of tabbar
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.rain.fill")
                }
                .tag(0)
            ChartView(viewModel: .init())
                .tabItem {
                    Label("Chart", systemImage: "chart.bar.xaxis")
                }
                .tag(1)
        }
        .onAppear {
            UITabBar.appearance().barTintColor = .white
        }
    }
}
