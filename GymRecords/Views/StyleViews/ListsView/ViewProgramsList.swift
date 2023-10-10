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
    @State var newProgram = GymModel.Program(numberOfProgram: 1,programTitle: "", programDescription: "", colorDesign: "green", exercises: [])
    var body: some View {
        VStack{
            // Add Programm Button
            VStack{
                Button {
                    HapticManager.instance.impact(style: .medium)
                    createNewProgrammSheet.toggle()
                } label: {
                    Text("Create program")
                        .font(.custom("Helvetica", size: viewModel.constW(w:22)))
                        .fontWeight(.bold)
                    Spacer()
                    Text("+")
                        .fontWeight(.regular)
                }
                .foregroundColor(Color("backgroundDarkColor"))
                .font(.custom("Helvetica", size: viewModel.constW(w:26)))
                .fontWeight(.bold)
                .padding(.trailing,10)
                .padding(20)
                .background(Rectangle()
                    .foregroundColor(Color("LightGrayColor"))
                    .frame(width: viewModel.screenWidth - 20, height: viewModel.constH(h:60))
                    .cornerRadius(10))
                .padding(10)
            }
            .fullScreenCover(isPresented: $createNewProgrammSheet) {
                CreateNewProgrammView(name: $newProgram.programTitle, description: $newProgram.programDescription, exercises: $newProgram.exercises, colorDesignStringValue: $newProgram.colorDesign,toChangeProgram: false)
            }
            // List of created custom Programms
            
            ScrollView {
                ForEach(viewModel.programList.indices,id:\.self) { elem in
                    if viewModel.programList[elem].programDescription != "" {
                        ProgramItemListView(programm: $viewModel.programList[elem])
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    viewModel.showedEdirOrRemoveProgram = viewModel.programList[elem]
                                    viewModel.isShowedEditOrRemoveView.toggle()
                                }
                                
                            }
                            .padding(.top)
                            .padding(.bottom,-10)
                    }
                }
            }
            Spacer()
            
        }
        .ignoresSafeArea(.all, edges: .bottom)
        
    }
    
}









struct ViewProgrammsList_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()

        ViewProgramsList().environmentObject(GymViewModel())
    }
}
