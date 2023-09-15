//
//  AddProgrammView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 28.01.2023.
//

import SwiftUI

struct AddProgramView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:GymViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isSearching {
                    //Search View
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .fixedSize()
                        
                            .padding([.leading,.top,.bottom],10)
                        
                        TextField("", text: $viewModel.searchWord)
                            .placeholder(when: viewModel.searchWord.isEmpty) {
                                Text("Find:").foregroundColor(Color("MidGrayColor"))
                            }
                            .onChange(of: viewModel.searchWord) {newValue in
                                
                                viewModel.arrayOfFoundExercise = viewModel.findAnyExerciseByLetters(letters: viewModel.searchWord, array: viewModel.arrayExercises)
                            }
                            .tint(.black)
                            .foregroundColor(.black)
                            .font(.custom("Helvetica", size: viewModel.constW(w:18)))
                    }
                    .foregroundColor(Color("MidGrayColor"))
                    .background(Rectangle()
                        .cornerRadius(viewModel.viewCornerRadiusSimple)
                        .foregroundColor(Color("LightGrayColor")))
                    .padding([.top,.bottom], 2)
                    .padding([.leading,.trailing], 10)
                }
                //View of Programms and Exercise with selection
                ExercisesAndProgramsListView()
                    
                //                    .environmentObject(viewModel)
                
                
            }.opacity(viewModel.isShowedEditOrRemoveView ? 0 : 1)
                .opacity(viewModel.isShowedViewListSpecificExercise ? 0 : 1)
                .background(.white)
//                .position(x: viewModel.screenWidth / 2,y:400)
                .onTapGesture {
                    self.hideKeyboard()
                }
                .padding(.top,30)
                .ignoresSafeArea(.keyboard)
            if viewModel.isShowedEditOrRemoveView {
                let program = viewModel.showedEdirOrRemoveProgram
                EditOrRemoveTheProgram(program: program, isShowedView: $viewModel.isShowedEditOrRemoveView )
                
                
            }
            
            if viewModel.isShowedViewListSpecificExercise {
                let type = viewModel.showedViewListSpecificExercise
                ViewListSpecificExercises(
                    typeOfExercise: type,isPresented: $viewModel.isShowedViewListSpecificExercise, exerciseProgramming: false)
                //                .environmentObject(viewModel)
                
            }
            
        }
        
    }
    
}










struct AddProgrammView_Previews: PreviewProvider {
    static var previews: some View {
        let migrator = Migrator()
        
        AddProgramView().environmentObject(GymViewModel())
    }
}
