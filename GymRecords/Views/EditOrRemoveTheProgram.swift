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
    @Binding var program:GymModel.Program
    @State var showSheet:Bool = false
    @State var showAlert = false
    @State var IsProgramDeleted = false
    @State var isEditProgram = false
    
    var body: some View {
        VStack(alignment:.leading){
            Text("Program")
                .padding([.leading,.trailing],40)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top,20)
            
            ProgramItemListView(programm: $program)
            VStack {
                ForEach(program.exercises,id: \.id) { elem in
                    HStack {
                        
                        Image(elem.type.rawValue)
                            .padding(.leading,20)
                        Text(elem.name.capitalized)
                            .padding(.leading,10)
                            .frame(width: 300,height: 50,alignment: .leading)
                            .foregroundColor(.black)
                            .font(.custom("Helvetica", size: 20))
                            .fontWeight(.bold)
                    }
                    .padding(.leading,20)
                }
                
            }
            Spacer()
            
            HStack {
                //Back button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .padding(10)
                }
                .font(.custom("Helvetica", size: 20))
                .background(Circle()
                    .frame(width: 40,height: 40)
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
                .font(.custom("Helvetica", size: 20))
                .background(Circle()
                    .frame(width: 40,height: 40)
                    .foregroundColor(Color("MidGrayColor")))
                .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
                    
                } content: {
                    VStack {
                        Button {
                            showAlert.toggle()
                            
                            
                        } label: {
                            Text("Delete program")
                                .foregroundStyle(Color("RedColorScarlet").gradient)
                        }
                        .padding(.bottom,10)
                        .alert(isPresented:$showAlert, content:  {
                            Alert(title: Text("Are you sure?"),message:Text("This action cannot be undone"), primaryButton: .default(Text("Yes"),action: {
                                
                                viewModel.removeProgram(program: program)
                                IsProgramDeleted.toggle()
                                showSheet.toggle()
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
                            CreateNewProgrammView(name: $program.programTitle, description: $program.description, exercises: $program.exercises, colorDesignStringValue: $program.colorDesign)
                            
                        }
                    }
                    .font(.custom("Helvetica", size: 25))
                    .fontWeight(.bold)
                    .presentationDetents([.fraction(0.25)])
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .presentationDragIndicator(.visible)
                    
                    
                    
                }
                .onDisappear {
                    if IsProgramDeleted {
                        dismiss()
                    }
                }
                
                
            }
            
        }
        
    }
}

struct EditOrRemoveTheProgramm_Previews: PreviewProvider {
    static var previews: some View {
        EditOrRemoveTheProgram(program: .constant(GymModel.programs[0])).environmentObject(GymViewModel())
    }
}
