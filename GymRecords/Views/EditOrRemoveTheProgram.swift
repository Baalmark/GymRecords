//
//  EditOrRemoveTheProgramm.swift
//  GymRecords
//
//  Created by Pavel Goldman on 10.02.2023.
//

import SwiftUI

struct EditOrRemoveTheProgram: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @State var program:GymModel.Program
    @State var showSheet:Bool = false
    @State var showAlert = false
    @State var IsProgramDeleted = false
    @State var isEditProgram = false
    @Binding var isShowedView:Bool
    var body: some View {
        VStack(alignment:.leading){
            Text("Program")
                .padding([.leading,.trailing],40)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top,30)
            
            ProgramItemListView(programm: $program)
                .padding(.bottom,20)
            
            
            ScrollView {
                ForEach(program.exercises,id: \.id) { elem in
                    HStack {
                        
                        Image(elem.type.rawValue)
                            .padding(.leading,20)
                        Text(elem.name.capitalized)
                            .padding(.leading,10)
                            .frame(width: viewModel.constW(w:300),height: viewModel.constH(h:50),alignment: .leading)
                            .foregroundColor(Color("backgroundDarkColor"))
                            .font(.custom("Helvetica", size: viewModel.constW(w:16)))
                            .fontWeight(.bold)
                    }
                    .padding(.leading,20)
                }
                
            }
            Spacer()
            
            HStack {
                //Back button
                Button {
                    withAnimation(.easeInOut) {
                        viewModel.isShowedEditOrRemoveView.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .padding(10)
                }
                .font(.custom("Helvetica", size: viewModel.constW(w:20)))
                .background(Circle()
                    .frame(width: viewModel.constW(w:40),height: viewModel.constW(w:40))
                    .foregroundColor(Color("MidGrayColor")))
                .padding(.leading,15)
                //Edit or Remove
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding(10)
                }
                .font(.custom("Helvetica", size: viewModel.constW(w:20)))
                .background(Circle()
                    .frame(width: viewModel.constW(w:40),height: viewModel.constW(w:40))
                    .foregroundColor(Color("MidGrayColor")))
                .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
                    
                } content: {
                    VStack {
                        Button {
                            showAlert.toggle()
                            
                            
                        } label: {
                            Text("Delete program")
                                .foregroundStyle(Color("BrightRedColor").gradient)
                        }
                        .padding(.bottom,10)
                        .alert(isPresented:$showAlert, content:  {
                            Alert(title: Text("Are you sure?"),message:Text("This action cannot be undone"), primaryButton: .default(Text("Yes"),action: {
                                
                                viewModel.removeProgram(program: program)
                                withAnimation(.easeInOut) {
                                    IsProgramDeleted.toggle()
                                    viewModel.isShowedEditOrRemoveView.toggle()
                                }
                            }), secondaryButton: .cancel(Text("Cancel")))
                            
                        })
                        
                        Button {
                            isEditProgram.toggle()
                            viewModel.selectedExArray = program.exercises
                        } label: {
                            Text("Edit program")
                                .foregroundStyle(.white.gradient)
                            
                        }
                        
                        .fullScreenCover(isPresented: $isEditProgram) {
                            CreateNewProgrammView(name: $program.programTitle, description: $program.programDescription, exercises: $program.exercises, colorDesignStringValue: $program.colorDesign,toChangeProgram:true)
                            
                        }
                    }
                    .font(.custom("Helvetica", size: viewModel.constW(w:25)))
                    .fontWeight(.bold)
                    .presentationDetents([.fraction(0.25)])
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .presentationDragIndicator(.visible)
                    
                    
                    
                }
                
                Button {
                    
                    viewModel.selectingProgrammForNewTrainingDay(program: program)
                    if let newTrainingDay = viewModel.selectedProgramForNewTrainingDay {
                        viewModel.createTraining(date: viewModel.selectedDate, program: newTrainingDay)
                    }
                    viewModel.selectedProgramForNewTrainingDay = nil
                    viewModel.isShowedEditOrRemoveView = false
                    dismiss()
                } label: {
                    Text("Ready")
                        .font(.title3)
                        .fontWeight(.bold)
                }.buttonStyle(GrowingButton(isDarkMode: false, width: viewModel.constW(w:220), height: viewModel.constH(h:40)))
                    .padding(20)
            }
            
        }
        
    }
}

struct EditOrRemoveTheProgramm_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()
        EditOrRemoveTheProgram(program: GymModel().programs[0], isShowedView: .constant(true)).environmentObject(GymViewModel())
    }
}
