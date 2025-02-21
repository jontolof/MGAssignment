//
//  AnimationViewModifiers.swift
//  MarshallCrypto
//
//  Created by Jont Olof Lyttkens on 2025-02-21.
//

// Let's make an animation to wiggle a view. Used
// In the details view for the currency logo
import SwiftUI

struct WiggleAnimation: ViewModifier {
    let isAnimating : Bool
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isAnimating ? 10 : 0))
            .scaleEffect(isAnimating ? 1.05 : 1.0)
        // A "forever" animation does not stop unless replaced with an animation that does not repeat, dispite providing a 'value'. Potential bug in the framework.
            .animation( isAnimating ? Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true) : Animation.easeInOut(duration: 0.4),
                        value: isAnimating
            )
    }
}

// make ViewModifer accessible via a View extension for easy and clean access.
extension View {
    func wiggleAnimation(isAnimating animating: Bool) -> some View {
        modifier(WiggleAnimation(isAnimating: animating))
    }
}
