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
            .background(!isDarkMode ? .black : .white)
            .foregroundColor(!isDarkMode ? .white : .black)
            .clipShape(Rectangle())
            .cornerRadius(15)
            .shadow(color: .gray, radius: 3)
            .scaleEffect(configuration.isPressed ? 1.5 : 1)
            .animation(.easeOut(duration: 0.33), value: configuration.isPressed)
    }
}


//Buffer
//VStack(alignment: .center){
////Little button for unwrapping the Calendar View
//    VStack{
//        Text("")
//            .background(Rectangle()
//                .frame(width: 150,height: 10)
//                .foregroundColor(systemColor)
//                .border(.white,width: 2.5)
//            )
//
//        Text("")
//            .background(Rectangle()
//                .frame(width: viewModel.screenWidth,height: 15)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                .shadow(color: systemShadowColor, radius: 5,x: 0,y: 9)
//            )
//    }
//    //Gesture for unwrapping the Calendar View
//    .gesture(
//        DragGesture()
//            .onChanged { value in
//                print(value)
//
//
//            }
//            .onEnded { value in
//
//            })
