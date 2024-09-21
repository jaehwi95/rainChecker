//
//  Card.swift
//  rainChecker
//
//  Created by Jaehwi Kim on 2024/07/15.
//

import SwiftUI

struct FlipCardView<FrontView: View, BackView: View>: View {
    private let frontView: FrontView
    private let backView: BackView
    @Binding private var isFlip: Bool
    private let cardSize: CGFloat
    
    public init(frontView: FrontView, backView: BackView, isFlip: Binding<Bool>, cardSize: CGFloat = 100) {
        self.frontView = frontView
        self.backView = backView
        _isFlip = isFlip
        self.cardSize = cardSize
    }
    
    var body: some View {
        ZStack() {
            frontView
                .card(size: cardSize)
                .modifier(FlipOpacity(percentage: isFlip ? 0 : 1))
                .rotation3DEffect(
                    Angle.degrees(isFlip ? 180 : 360),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            backView
                .card(size: cardSize)
                .modifier(FlipOpacity(percentage: isFlip ? 1 : 0))
                .rotation3DEffect(
                    Angle.degrees(isFlip ? 0 : 180),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
        }
        .onTapGesture {
            withAnimation {
                self.isFlip.toggle()
            }
        }
    }
}

private struct FlipOpacity: AnimatableModifier {
    var percentage: CGFloat = 0
    
    var animatableData: CGFloat {
        get { percentage }
        set { percentage = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(Double(percentage.rounded()))
    }
}

private struct CardModifier: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.2)))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 1)
    }
}

private extension View {
    func card(size: CGFloat) -> some View {
        modifier(CardModifier(size: size))
    }
}

#Preview {
    FlipCardView(
        frontView: EmptyView(),
        backView: EmptyView(),
        isFlip: .constant(true),
        cardSize: 100
    )
}
