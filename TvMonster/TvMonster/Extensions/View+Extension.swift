//
//  View+Extension.swift
//  TvMonster
//
//  Created by Obed Garcia on 4/6/22.
//

import SwiftUI

extension View {
    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeModifier(cornerRadius: cornerRadius))
    }
}

extension View {
    func cardStyle(cornerRadius: CGFloat) -> some View {
        return self
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
