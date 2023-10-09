//
//  GrowingButton.swift
//  GymRecords
//
//  Created by Pavel Goldman on 02.03.2023.
//

import SwiftUI


struct GrowingButton: ButtonStyle {
    
    var isDarkMode:Bool
    var width:CGFloat
    var height:CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: width,height: height)
            .background(!isDarkMode ? Color("backgroundDarkColor") : .white)
            .foregroundColor(!isDarkMode ? .white : Color("backgroundDarkColor"))
            .clipShape(Rectangle())
            .cornerRadius(15)
            .shadow(color: .gray, radius: 3)
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.33), value: configuration.isPressed)
    }
}


