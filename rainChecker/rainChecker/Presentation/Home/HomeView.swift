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
            if #available(iOS 15, *) {
                let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithTransparentBackground()
                tabBarAppearance.backgroundEffect = UIBlurEffect(style: .light)
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}
