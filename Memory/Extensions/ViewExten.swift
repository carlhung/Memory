//
//  ViewExten.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

import SwiftUI

private struct DefaultTextConfig: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .multilineTextAlignment(.leading)
    }
}

private struct DefaultNavigationBarConfig: ViewModifier {
    
    let barText: String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(barText)
            .navigationBarTitleDisplayMode(.inline)
    }
}

private struct DefaultRoundedRectangle: ViewModifier {
    
    var color: Color
    var lineWidth: CGFloat
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}

extension View {
    func defaultTextConfig() -> some View {
        modifier(DefaultTextConfig())
    }
    
    func defaultNavigationBarConfig(barText: String) -> some View {
        modifier(DefaultNavigationBarConfig(barText: barText))
    }
    
    func defaultRoundedRectangle(
        _ color: Color = .blue,
        lineWidth: CGFloat = 4,
        cornerRadius: CGFloat = 16
    ) -> some View {
        modifier(
            DefaultRoundedRectangle(
                color: color,
                lineWidth: lineWidth,
                cornerRadius:  cornerRadius
            )
        )
    }
}
