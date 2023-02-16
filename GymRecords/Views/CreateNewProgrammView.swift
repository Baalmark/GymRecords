//
//  CreateNewProgrammView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 13.02.2023.
//

import SwiftUI

struct CreateNewProgrammView: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @State var name = ""
    @State var description = ""
    @State var colorDesign:Color = .green
    @State var exercises:[Exercise] = []
    @State var isColorSelected:Color = .green
    @State var colorDesignStringValue:String = "green"
    @State var isShowExercises = false
    @State private var selectedRows: [String] = []
    var body: some View {
        VStack {
            //Close button
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.white)
                    .fixedSize()
                    .font(.title2)
            }
            .offset(x:viewModel.screenWidth / 2,y:0)
            .padding(.trailing,70)
            
            VStack {
                //New Programm Card with TextFields
                VStack {
                    
                    TextField("", text: $name)
                        .font(.title2)
                        .placeholder(when: name.isEmpty) {
                            Text("Title of Programm ")
                                .foregroundColor(.white)
                                .font(.title2)
                        }.opacity(0.7)
                    
                    TextField("",text:$description)
                        .font(.headline)
                        .placeholder(when: name.isEmpty) {
                            Text("Description")
                                .foregroundColor(.white)
                                .font(.headline)
                        }.opacity(0.7)
                    
                }
                .frame(width: viewModel.screenWidth - 50,height: 62)
                .padding([.top,.bottom],5)
                .padding([.leading,.trailing],15)
                .background(RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(colorDesign.gradient))
                
                ScrollView(.horizontal,showsIndicators: false){
                    HStack(spacing:10){
                        ForEach(viewModel.colors,id:\.self) { color in
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color[color].gradient)
                                    .onTapGesture{
                                        
                                        
                                        colorDesignStringValue = color
                                        colorDesign = Color[color]
                                        isColorSelected = Color[color]
                                        
                                        
                                    }
                                Image(systemName: "checkmark")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.white)
                                    .fixedSize()
                                    .font(.callout)
                                    .opacity(isColorSelected == Color[color] ? 1 : 0)
                            }
                        }
                        .frame(width: 44,height: 44)
                    }
                }
                
                .frame(width: viewModel.screenWidth - 20,height: 72)
                .background(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color("DarkbackgroundViewColor")))
                
                
                Button {
                    isShowExercises.toggle()
                    viewModel.changeExercisesDB = false
                } label: {
                    Text("Add exercises")
                    Spacer()
                    Text("+")
                    
                }
                .foregroundColor(.white)
                .padding(.leading,15)
                .padding(.trailing,25)
                .frame(width: viewModel.screenWidth - 20,height: 72)
                .background(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color("DarkbackgroundViewColor")))
                
                
                if viewModel.selectedExArray.isEmpty {
                    
                } else {
                    List {
                        
                        ForEach(Array(viewModel.selectedExArray.enumerated()), id:\.offset) {index,elem in
                            HStack(alignment:.center) {
                                Text(elem.name)
                                
                                Spacer()
                                Image(systemName: "line.3.horizontal")
                            }
                            
                            .padding([.bottom,.top], 10)
                            .font(.custom("Helvetica", size: 20))
                            .foregroundColor(.white)
                            .background(Color( self.selectedRows.contains(elem.name) ? "DarkbackgroundViewColor" :"backgroundDarkColor").animation(.easeInOut))
                            .listRowBackground(Color( self.selectedRows.contains(elem.name) ? "DarkbackgroundViewColor" :"backgroundDarkColor").animation(.easeInOut))
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    if selectedRows.contains(elem.name) {
                                        selectedRows = selectedRows.filter({$0 != elem.name})
                                    } else {
                                        self.selectedRows.append(elem.name)
                                    }
                                }
                            }
                        }.onDelete(perform: { indexSet in
                            viewModel.selectedExArray.remove(atOffsets: indexSet)
                            
                        })
                        .onMove(perform: { from, to in
                            
                        })
                        
                        .listRowSeparator(.hidden)
                        
                    }
                    
                    .listStyle(.plain)
                    .padding([.leading,.trailing],-10)
                    .scrollContentBackground(.hidden)
                }
                
                Spacer()
                if name != "",exercises.count != 0 {
                    Button("Create exercise") {
                        if name != "" {
                            let newProgramm = GymModel.Program(programTitle: name, description: description, colorDesign: colorDesignStringValue, exercises: exercises)
                        }
                        dismiss()
                    }
                    .buttonStyle(GrowingButton(isDarkMode: true,width: 335 - 50,height: 45))
                    .foregroundColor(Color("DarkGrayColor"))
                }
                
            }
            .font(.title2)
            .fontWeight(.bold)
            .padding(10)
            
            
        }.background(Color("backgroundDarkColor"))
            .onTapGesture {
                self.hideKeyboard()
            }
            .fullScreenCover(isPresented: $isShowExercises) {
                ViewExerciseList(withCategory: false, toggleArray: $viewModel.selectedExArray, shouldHideButton: $viewModel.isSelectedSomeExercise, programmingExercise: true).environmentObject(viewModel)
            }
    }
    
}

struct CreateNewProgrammView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewProgrammView().environmentObject(GymViewModel())
    }
}
