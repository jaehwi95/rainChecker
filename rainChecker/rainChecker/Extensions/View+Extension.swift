//
//  View+Extension.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 6/28/24.
//

import Foundation
import SwiftUI

public extension View {
    func fullWidth() -> some View {
        frame(maxWidth: .infinity)
    }
    
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}
