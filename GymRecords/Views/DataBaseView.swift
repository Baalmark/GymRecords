//
//  DataBaseView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 09.02.2023.
//

import SwiftUI

struct DataBaseView: View {
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            VStack {
                VStack{
                    HStack{
                        Text("Database")
                        
                        Spacer()
                        Button{
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Color("MidGrayColor"))
                                .font(.custom("Helvetica", size: 16))
                        }
                    }
                    .padding([.leading,.trailing],30)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top,20)
                    DataBaseInfoTitle()
//                        .environmentObject(viewModel)
                        .padding(5)
                }
                ExercisesAndProgramsListView()
//                    .environmentObject(viewModel)
            }.opacity(viewModel.isShowedEditOrRemoveView ? 0 : 1)
                .opacity(viewModel.isShowedViewListSpecificExercise ? 0 : 1)
            if viewModel.isShowedEditOrRemoveView {
                let program = viewModel.showedEdirOrRemoveProgram
                    EditOrRemoveTheProgram(program: program, isShowedView: $viewModel.isShowedEditOrRemoveView )
            }
            if viewModel.isShowedViewListSpecificExercise {
                let type = viewModel.showedViewListSpecificExercise
                    ViewListSpecificExercises(typeOfExercise: type, isPresented: $viewModel.isShowedViewListSpecificExercise, exerciseProgramming: false)
                
            }
            
        }
    }
}


struct DataBaseView_Previews: PreviewProvider {
    static var previews: some View {
        let migrator = Migrator()

        DataBaseView().environmentObject(GymViewModel())
    }
}
