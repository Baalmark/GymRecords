//
//  ViewExerciseList.swift
//  GymRecords
//
//  Created by Pavel Goldman on 31.01.2023.
//

import SwiftUI

struct ViewExerciseList: View {
    
    private var viewModel = GymViewModel()
    
    var body: some View {
        VStack {
// Exercise Button
            HStack {
                Text("Create Exercise")
                    .font(.custom("Helvetica", size: 22))
                    .fontWeight(.bold)
                Spacer()
                Button("+") {
                    //
                }
                .foregroundColor(.black)
                .font(.custom("Helvetica", size: 26))
                .fontWeight(.bold)
                .padding(.trailing,10)
            }
            .padding(20)
            .background(Rectangle()
                .foregroundColor(viewModel.systemColorLightGray)
                .frame(width: viewModel.screenWidth - 20, height: 60)
                .cornerRadius(10))
            .padding(10)
            
//List of exercises
            VStack() {
                ForEach(viewModel.exerciseList, id:\.id) {elem in
                    HStack{
                        
                        Image(elem.rawValue)
                        Text(elem.rawValue.capitalized)
                            .padding(.leading,10)
                            .frame(width: 110,height: 50,alignment: .leading)
                            .foregroundColor(.black)
                            .font(.custom("Helvetica", size: 20))
                            .fontWeight(.bold)
                        
                        
                        Spacer()
                        HStack {
                            Text("0") //Model doesn't complete yet
                            Image(systemName: "greaterthan")
                        }
                        .foregroundColor(viewModel.systemColorGray)
                        .fontWeight(.bold)
                    }
                    .padding([.leading,.trailing],30)
                }
            }
        }
        Spacer()
    }
}













struct ViewExerciseList_Previews: PreviewProvider {
    static var previews: some View {
        ViewExerciseList()
    }
}
