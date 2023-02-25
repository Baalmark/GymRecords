//
//  AddProgrammView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 28.01.2023.
//

import SwiftUI

struct AddProgramView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchWord = ""
    @EnvironmentObject var viewModel:GymViewModel
    
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(.gray)
                        .padding([.leading,.top,.bottom],10)
                    
                    TextField("Find:", text: $searchWord)
                        .foregroundColor(.gray)
                        .tint(.gray)
                        .font(.custom("Helvetica", size: 20))
                        .fontWeight(.black)
                    
                    
                }
                .background(Rectangle()
                    .cornerRadius(viewModel.viewCornerRadiusSimple)
                    .foregroundColor(Color("LightGrayColor")))
                .padding([.top,.bottom], 2)
                .padding([.leading,.trailing], 10)
                
                //View of Programms and Exercise with selection
                ExercisesAndProgramsListView().environmentObject(viewModel)
                
            }.opacity(viewModel.isShowedEditOrRemoveView ? 0 : 1)
                .opacity(viewModel.isShowedViewListSpecificExercise ? 0 : 1)
            .background(.white)
            .position(x: viewModel.screenWidth / 2,y:400)
            .onTapGesture {
                self.hideKeyboard()
            }
            .ignoresSafeArea(.keyboard)
            if viewModel.isShowedEditOrRemoveView {
                if let program = viewModel.showedEdirOrRemoveProgram {
                        EditOrRemoveTheProgram(program: program, isShowedView: $viewModel.isShowedEditOrRemoveView )
                    
                }
            }
            
            if viewModel.isShowedViewListSpecificExercise {
                if let type = viewModel.showedViewListSpecificExercise {
                        ViewListSpecificExercises(
                            typeOfExercise: type,isPresented: $viewModel.isShowedViewListSpecificExercise, exerciseProgramming: false).environmentObject(viewModel)
                }
            }
            
        }
        
    }
    
}










struct AddProgrammView_Previews: PreviewProvider {
    static var previews: some View {
        AddProgramView().environmentObject(GymViewModel())
    }
}
