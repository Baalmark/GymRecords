//
//  CustomCircleShapeView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 07.02.2023.
//

import SwiftUI






struct CustomCircleShapeView: View {
    var length:CGFloat
    var body: some View {
        CustomCircleShape(length: length)    }
}


struct CustomCircleShape:Shape {
    
    var length:CGFloat
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            path.addArc(center: CGPoint(x: rect.minX, y: rect.midY),
                        radius: rect.height / 2,
                        startAngle: Angle(degrees: -90),
                        endAngle: Angle(degrees: 90),
                        clockwise: true)
            path.addLine(to: CGPoint(x: length, y: rect.maxY))
            
            path.addArc(center: CGPoint(x: rect.minX + length, y: rect.midY),
                        radius: rect.height / 2,
                        startAngle: Angle(degrees: 90),
                        endAngle: Angle(degrees: -90),
                        clockwise: true)
         
        }
    }
}


struct CustomCircleShapeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCircleShapeView(length: 10)
    }
}
