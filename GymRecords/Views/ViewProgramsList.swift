//
//  ViewProgrammsList.swift
//  GymRecords
//
//  Created by Pavel Goldman on 31.01.2023.
//

import SwiftUI

struct ViewProgramsList: View {
    @EnvironmentObject var viewModel:GymViewModel
    @State var isSheetActivated = false
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
                ForEach(viewModel.programList.indices,id:\.self) { elem in
                    ProgramItemListView(programm: $viewModel.programList[elem])
                    .onTapGesture {
                        isSheetActivated.toggle()
                    }
                }.sheet(isPresented: $isSheetActivated) {
                    EditOrRemoveTheProgram()
                }
            }
            Spacer()
        }
        
    }
}








struct ViewProgrammsList_Previews: PreviewProvider {
    static var previews: some View {
        ViewProgramsList().environmentObject(GymViewModel())
    }
}
