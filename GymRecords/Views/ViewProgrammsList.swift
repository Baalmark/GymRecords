//
//  ViewProgrammsList.swift
//  GymRecords
//
//  Created by Pavel Goldman on 31.01.2023.
//

import SwiftUI

struct ViewProgrammsList: View {
    @EnvironmentObject var viewModel:GymViewModel
    var body: some View {
        VStack{
// Add Programm Button
            HStack {
                Text("Create Programm")
                    .font(.custom("Helvetica", size: 22))
                    .fontWeight(.bold)
                Spacer()
                Button("+") {
                    //
                }
                .foregroundColor(.black)
                .font(.custom("Helvetica", size: 26))
                .fontWeight(.bold)
            }
            .padding([.top,.bottom,.trailing],30)
            .padding(.leading,20)
            .background(Rectangle()
                .foregroundColor(viewModel.systemColorLightGray)
                .frame(width: viewModel.screenWidth - 20, height: 60)
                .cornerRadius(10))
            .padding([.leading,.trailing],10)
            
// List of created custom Programms
            
            VStack {
                ForEach(viewModel.programmList,id:\.id) { elem in
                    HStack {
                        Text("\(elem.description)")
                            .padding(.leading,20)
                            .font(.custom("Helvetica", size: 20))
                            .fontWeight(.bold)
                            .padding(.leading,10)
                        Spacer()
                        Text("\(elem.countOfExcercises)")
                            .background(Circle()
                                .frame(width: 50,height: 50)
                                .foregroundColor(viewModel.circleColor)
                                
                            )
                            .padding(.trailing,30)
                        
                    }
                    .background(Rectangle()
                        .frame(width: viewModel.screenWidth - 20,height: 60)
                        .foregroundColor(Color[elem.colorDesign])
                        .cornerRadius(10)
                    )
                    .padding(10)
                }
            }
            Spacer()
        }
        
    }
}








struct ViewProgrammsList_Previews: PreviewProvider {
    static var previews: some View {
        ViewProgrammsList().environmentObject(GymViewModel())
    }
}
