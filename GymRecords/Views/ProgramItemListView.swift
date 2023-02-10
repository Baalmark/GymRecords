//
//  ProgrammItemListView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 10.02.2023.
//

import SwiftUI

struct ProgramItemListView: View {
    @EnvironmentObject var viewModel:GymViewModel
    @Binding var programm:GymModel.Program
    
    var body: some View {
        HStack {
            Text("\(programm.description)")
                .padding(.leading,20)
                .font(.custom("Helvetica", size: 20))
                .fontWeight(.bold)
                .padding(.leading,10)
            Spacer()
            Text("\(programm.countOfExcercises)")
                .font(.title2)
                .fontWeight(.bold)
                .background(Circle()
                    .frame(width: 50,height: 50)
                    .foregroundColor(viewModel.circleColor)
                    
                )
                .padding(.trailing,30)
            
        }
        .foregroundColor(.white)
        .background(RoundedRectangle(cornerRadius: 10)
            .frame(width: viewModel.screenWidth - 20,height: 60)
                    
            .foregroundStyle(LinearGradient(colors: [.orange, Color[programm.colorDesign]],
                                           startPoint: .top,
                                           endPoint: .center))
            
        )
        .padding(10)    }
}

struct ProgrammItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramItemListView(programm: .constant(GymModel.programs[0])).environmentObject(GymViewModel())
    }
}
