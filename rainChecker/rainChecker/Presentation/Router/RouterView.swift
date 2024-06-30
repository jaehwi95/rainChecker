//
//  RouterView.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/12/24.
//

import SwiftUI

class Router: ObservableObject {
    enum Route: Hashable {
        case mainWeatherView
        case chartView
    }
    
    @Published var path: NavigationPath = NavigationPath()
    
    @MainActor 
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .mainWeatherView:
            MainWeatherView(viewModel: .init())
        case .chartView:
            ChartView(viewModel: .init())
        }
    }
    
    func navigateTo(_ route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
