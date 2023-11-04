//
//  PinButtonStyle.swift
//  Pitchpin
//
//  Created by Aditya Saravana on 11/4/23.
//

import SwiftUI

struct PinButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.yellow)
            .foregroundColor(.white)
            .clipShape(Circle())
//            .scaleEffect(configuration.isPressed ? 1.1 : 1)
//            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

