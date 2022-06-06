//
//  ButtonStyle.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import Foundation
import SwiftUI

struct TTapButtontyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct TButtontyle: ButtonStyle {
    var buttonStyle: ThemeButtonStyle = .primary
    var width: CGFloat = 150
    var height: CGFloat = 59
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .foregroundColor(buttonStyle == .primary ? .white : Color.theme.green)
            .padding()
            .frame(width: width, height: height)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(buttonStyle == .primary ? Color.theme.green : Color.white)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .shadow(color: buttonStyle == .primary
                    ? Color.theme.green.opacity(0.3)
                    : Color.white.opacity(0.3),
                    radius: 5, x: 0, y: 4)
    }
}

enum ThemeButtonStyle {
    case primary
    case secondary
}

