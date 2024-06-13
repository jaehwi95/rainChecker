//
//  rainCheckerApp.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/12/24.
//

import SwiftUI

@main
struct rainCheckerApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView {
                HomeView(viewModel: .init())
            }
        }
    }
}
