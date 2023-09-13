//
//  AddSetLittleView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 16.05.2023.
//

import SwiftUI

struct AddSetLittleView: View {
    var number:Int
    var screenWidth = UIScreen.main.bounds.width
    var body: some View {
            HStack {
                Text("\(number)")
                    .padding(.leading,-15)
                    .font(.callout.bold())
                    .foregroundColor(Color("MidGrayColor"))
                
                Text("Add Set")
                    .font(.custom("Helvetica", size: 24).bold())
                    .foregroundColor(.black)
                    .frame(width: screenWidth - 60,height: 70)
                    .background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color("LightGrayColor")))
            }
    }
}

struct AddSetLittleView_Previews: PreviewProvider {
    static var previews: some View {
        AddSetLittleView(number: 1)
    }
}
