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
    @Binding var name:String
    @Binding var description:String
    @State var colorDesign:Color = .green
    @Binding var exercises:[Exercise]
    @State var isColorSelected:Color = .green
    @Binding var colorDesignStringValue:String
    @State var isShowExercises = false
    @State private var selectedRows: [String] = []
    @State private var showDeleteButton = false
    var toChangeProgram:Bool
  
    var body: some View {
        VStack {
            //Close button
            Button {
                HapticManager.instance.impact(style: .medium)
                dismiss()
                viewModel.programToEdit = nil
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
                        .placeholder(when: description.isEmpty) {
                            Text("Description")
                                .foregroundColor(.white)
                                .font(.headline)
                        }.opacity(0.7)
                    
                }
                .frame(width: viewModel.screenWidth - 50,height: viewModel.constH(h:62))
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
                                        HapticManager.instance.impact(style: .soft)
                                        colorDesignStringValue = color
                                        colorDesign = Color[colorDesignStringValue]
                                        isColorSelected = Color[colorDesignStringValue]
                                        
                                        
                                    }
                                Image(systemName: "checkmark")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.white)
                                    .fixedSize()
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .opacity(isColorSelected == Color[color] ? 1 : 0)
                            }
                        }
                        .frame(width: viewModel.constW(w:44),height: viewModel.constW(w:44))
                    }
                }
                
                .frame(width: viewModel.screenWidth - 20,height: viewModel.constH(h:72))
                .background(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color("DarkbackgroundViewColor")))
                
                
                Button {
                    HapticManager.instance.impact(style: .medium)
                    isShowExercises.toggle()
                    viewModel.changeExercisesDB = false
                    viewModel.selectedCounterLabel = viewModel.computeSelectedCounderLabel()
                } label: {
                    Text("Add exercises")
                    Spacer()
                    Text("+")
                    
                }
                .foregroundColor(.white)
                .padding(.leading,15)
                .padding(.trailing,25)
                .frame(width: viewModel.screenWidth - 20,height: viewModel.constH(h:72))
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
                            
                            .padding(10)
                            .font(.custom("Helvetica", size: viewModel.constW(w:18)))
                            .foregroundColor(.white)
                            .background(Color( self.selectedRows.contains(elem.name) ? "DarkbackgroundViewColor" :"backgroundDarkColor").animation(.easeInOut))
                            .listRowBackground(Color( self.selectedRows.contains(elem.name) ? "DarkbackgroundViewColor" :"backgroundDarkColor").animation(.easeInOut))
                            .onTapGesture {
                                HapticManager.instance.impact(style: .soft)
                                withAnimation(.easeInOut) {
                                    if selectedRows.contains(elem.name) {
                                        selectedRows = selectedRows.filter({$0 != elem.name})
                                    } else {
                                        self.selectedRows.append(elem.name)
                                    }
                                    
                                    if selectedRows.count >= 1 {
                                        showDeleteButton = true
                                    }
                                }
                            }
                        }.onDelete(perform: { indexSet in
                            if let firtIndex = indexSet.first {
                                viewModel.unselectingExercise(exercise: viewModel.selectedExArray[firtIndex], isSelected: false)
                                viewModel.backButtonLabel = "\(viewModel.selectedExArray.count == 0 ? "" : "Selected: \(viewModel.selectedExArray.count)")"
                                viewModel.selectedCounterLabel = viewModel.computeSelectedCounderLabel()
                            }
                        })
                        .onMove(perform: { from, to in
                            viewModel.selectedExArray.move(fromOffsets: from, toOffset: to)
                        })
                        
                        .listRowSeparator(.hidden)
                        
                    }
                    
                    
                    .listStyle(.plain)
                    .padding([.leading,.trailing],-10)
                    .scrollContentBackground(.hidden)
                }
                Spacer()
                HStack {
                    Button {
                        HapticManager.instance.impact(style: .medium)
                        viewModel.unselectingCoupleOfExercise(arrayOfTitles: selectedRows, isSelected: false)
                    } label: {
                        Text("Remove")
                            .font(.custom("Helvetica", size: viewModel.constW(w:16)))
                            .foregroundColor(Color("BrightRedColor"))
                    }
                    Spacer()
                    Button {
                        HapticManager.instance.impact(style: .medium)
                        //
                    } label: {
                        Text("")
                            .font(.custom("Helvetica", size: viewModel.constW(w:16)))
                            .foregroundColor(.white)
                    }.opacity(selectedRows.count > 1 ? 0 : 1)
                }
                .padding(20)
                .opacity(selectedRows.isEmpty ? 0 : 1)
                
                Spacer()
                if !description.isEmpty, !name.isEmpty, !viewModel.selectedExArray.isEmpty {
                    Button("Save") {
                        HapticManager.instance.impact(style: .medium)
                        exercises = viewModel.selectedExArray
                        let newProgram = GymModel.Program(numberOfProgram: viewModel.getterNumberOfProgram(),programTitle: name, programDescription: description, colorDesign: colorDesignStringValue, exercises: exercises)
                        if toChangeProgram {
                            viewModel.editProgram(newProgram: newProgram)}
                        else {
                            viewModel.createNewProgram(program: newProgram)}
                        dismiss()
                        viewModel.programToEdit = nil
                        viewModel.clearSelectedExArray()
                        
                        
                    }
                    
                    .buttonStyle(GrowingButton(isDarkMode: true,width: viewModel.constW(w:335 - 50),height: viewModel.constH(h:45)))
                    .foregroundColor(Color("DarkGrayColor"))
                    
                }
                
            }
            
            .font(.title2)
            .fontWeight(.bold)
            .padding(10)
            
            
        }
        
        .background(Color("backgroundDarkColor"))
            
            .onTapGesture {
                self.hideKeyboard()
            }
            .fullScreenCover(isPresented: $isShowExercises) {
                ViewExerciseList(withCategory: false, shouldHideButton: $viewModel.isSelectedSomeExercise, programmingExercise: true)
            }
    }
    
}

struct CreateNewProgrammView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()

        CreateNewProgrammView(name: .constant(""), description: .constant(""), exercises: .constant([]), colorDesignStringValue: .constant("green"), toChangeProgram: true).environmentObject(GymViewModel())
    }
}
