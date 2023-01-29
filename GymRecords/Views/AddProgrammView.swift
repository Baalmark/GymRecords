//
//  AddProgrammView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 28.01.2023.
//

import SwiftUI

struct AddProgrammView: View {
    @State private var searchWord = ""
    private var screenWidth = UIScreen.main.bounds.width
    private var paddingSafeArea = 20
    private var systemColor = Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
    var body: some View {
       VStack {
            TextField("Find:", text: $searchWord)
               .frame(width: screenWidth - CGFloat(paddingSafeArea * 2),height: 50)
               .background(Rectangle()
                .cornerRadius(20)
                .foregroundColor(systemColor)
               )
            HStack {
                
            }
            ScrollView {
                
            }
            
        }
       .position(x: screenWidth / 2,y:400)
    }
}








struct AddProgrammView_Previews: PreviewProvider {
    static var previews: some View {
        AddProgrammView()
    }
}
