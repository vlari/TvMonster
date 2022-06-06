//
//  TProgressView.swift
//  TvMonster
//
//  Created by Obed Garcia on 6/6/22.
//

import SwiftUI

struct TProgressView: View {
    @State private var isRotating: Bool = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.theme.green,
                        style: StrokeStyle(lineWidth: 10,
                                           lineCap: CGLineCap.round)
                )
                .frame(width: 45, height: 45)
                .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isRotating)
                .onAppear {
                    isRotating = true
                }
        }
    }
}

struct TProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TProgressView()
    }
}
