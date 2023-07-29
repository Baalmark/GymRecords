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
    @State var createNewProgrammSheet = false
    @State var selectedProgram:GymModel.Program? = nil
    @State var newProgram = GymModel.Program(programTitle: "", programDescription: "", colorDesign: "green", exercises: [])
    var body: some View {
        VStack{
            // Add Programm Button
            VStack{
                Button {
                    createNewProgrammSheet.toggle()
                } label: {
                    Text("Create program")
                        .font(.custom("Helvetica", size: 22))
                        .fontWeight(.bold)
                    Spacer()
                    Text("+")
                        .fontWeight(.regular)
                }
                .foregroundColor(.black)
                .font(.custom("Helvetica", size: 26))
                .fontWeight(.bold)
                .padding(.trailing,10)
                .padding(20)
                .background(Rectangle()
                    .foregroundColor(Color("LightGrayColor"))
                    .frame(width: viewModel.screenWidth - 20, height: 60)
                    .cornerRadius(10))
                .padding(10)
            }
            .fullScreenCover(isPresented: $createNewProgrammSheet) {
                CreateNewProgrammView(name: $newProgram.programTitle, description: $newProgram.programDescription, exercises: $newProgram.exercises, colorDesignStringValue: $newProgram.colorDesign)
            }
            // List of created custom Programms
            
            VStack {
                ForEach(viewModel.programList.indices,id:\.self) { elem in
                    ProgramItemListView(programm: $viewModel.programList[elem])
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                //                                self.selectedProgram = viewModel.programList[elem]
                                //                                isSheetActivated.toggle()
                                viewModel.showedEdirOrRemoveProgram = viewModel.programList[elem]
                                viewModel.isShowedEditOrRemoveView.toggle()
                            }
                        }
                    //                        .fullScreenCover(item: self.$selectedProgram) { prog in
                    //                            EditOrRemoveTheProgram(program: prog, isShowedView: $isSheetActivated)
                    //                        }
                }
                
            }
            Spacer()
        }
        
    }
    
}









struct ViewProgrammsList_Previews: PreviewProvider {
    static var previews: some View {
        let migrator = Migrator()

        ViewProgramsList().environmentObject(GymViewModel())
    }
}
