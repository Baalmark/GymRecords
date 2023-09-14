//
//  ViewExerciseList.swift
//  GymRecords
//
//  Created by Pavel Goldman on 31.01.2023.
//

import SwiftUI

struct ViewExerciseList: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @State var withCategory:Bool
    @State var isTapped = false
    @State var selectedExer: GymModel.TypeOfExercise? = nil
    @State var showOverlay = false
    @State var showCreateExercise = false
    @Binding var shouldHideButton:Bool
    @State var programmingExercise:Bool
    
    var body: some View {
        ZStack {
            NavigationView{
                VStack {
                    
                    if withCategory{
                        //
                    } else {
                        
                        //Close button
                        HStack {
                            Text("New exercise")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding(.leading,30)
                                .fontWeight(.bold)
                            Spacer()
                            Button {
                                if programmingExercise == true {
                                    viewModel.changeExercisesDB = true
                                }
                                dismiss()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.white)
                                    .tint(.white)
                                    .fixedSize()
                                    .font(.title2)
                            }
                            
                            .padding(.trailing,20)
                            
                            
                        }
                        .padding(.bottom,50)
                        if !programmingExercise,!withCategory {
                            Text("Select a category")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(20)
                                .padding(.bottom,20)
                            
                        }
                    }
                    //List of exercises
                    
                    VStack() {
                        
                        ForEach(Array(viewModel.exerciseList.enumerated()), id:\.offset) {index,elem in
                            HStack{
                                
                                Image(withCategory ? elem.rawValue : elem.rawValue + "N")
                                Text(elem.rawValue.capitalized)
                                    .padding(.leading,10)
                                    .frame(width: viewModel.constW(w:110),height: viewModel.constH(h:50),alignment: .leading)
                                    .foregroundColor(withCategory ? .black : .white)
                                    .font(.custom("Helvetica", size: viewModel.constW(w:20)))
                                    .fontWeight(.bold)
                                
                                
                                Spacer()
                                // Display count of exercise and selected exercise if they are there
                                HStack {
                                    if viewModel.selectedCounterLabel.isEmpty { // If selected exercise dont exist
                                        Text("\(viewModel.findNumberOfExerciseOneType(type: elem, array: viewModel.arrayExercises))")
                                            .font(.custom("Helvetica", size: viewModel.constW(w:18)))
                                    } else {
                                        if viewModel.selectedCounterLabel[index] == 0 { // If selected exercises dont exist in some category
                                            Text("\(viewModel.findNumberOfExerciseOneType(type: elem, array: viewModel.arrayExercises))")
                                                .font(.custom("Helvetica", size: viewModel.constW(w:18)))
                                        } else { // Display selected exercises
                                            Text("Selected: \(viewModel.selectedCounterLabel[index])")
                                                .font(.custom("Helvetica", size: viewModel.constW(w:18)))
                                        }
                                    }
                                    Image(systemName: "chevron.forward")
                                        .font(.footnote)
                                    
                                    
                                    
                                }
                                .foregroundColor(withCategory ? Color("MidGrayColor") : .white)
                                .fontWeight(.bold)
                                
                            }
                            .padding([.leading,.trailing],30)
                            .padding(.bottom,withCategory ? 0 : 10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(withCategory ? .white : Color("backgroundDarkColor"))
                            )
                            .onTapGesture {
                                self.selectedExer = elem
                                isTapped = true
                                
                                if withCategory {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        viewModel.showedViewListSpecificExercise = elem
                                        viewModel.isShowedViewListSpecificExercise.toggle()
                                        
                                    }
                                } else {
                                    if programmingExercise == false {
                                        viewModel.showedViewListSpecificExercise = elem
                                        
                                        viewModel.isShowedCreateExView.toggle()
                                        showCreateExercise.toggle()
                                        
                                    } else {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            viewModel.showedViewListSpecificExercise = elem
                                            viewModel.isShowedViewListSpecificExercise.toggle()
//                                            viewModel.isShowedCreateExView.toggle()
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    Spacer()
                    if !withCategory, programmingExercise {
                        
                        Button("Add \(viewModel.selectedExArray.count)") {
                            dismiss()
                        }.buttonStyle(GrowingButton(isDarkMode: true,width: viewModel.constW(w:335),height: viewModel.constH(h:45)))
                            .tint(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .offset(x:0,y:viewModel.constH(h:-20))
                            .opacity(viewModel.selectedExArray.isEmpty ? 0 : 1)
                    }
                }
                .background(withCategory ? .white : Color("backgroundDarkColor"))
            }.overlay {
                if viewModel.isShowedCreateExView {
                    let type = viewModel.showedViewListSpecificExercise
                    CreateNewExercise(typeOfExercise: type, isNoCategoryCreating: true)
                        .onDisappear() {
                            dismiss()
                        }
                }
                if viewModel.isShowedViewListSpecificExercise {
                    let type = viewModel.showedViewListSpecificExercise
                    ViewListSpecificExercises(typeOfExercise: type, isPresented: $viewModel.isShowedViewListSpecificExercise, exerciseProgramming: programmingExercise)
                }
            }
        }
        }
    }













struct ViewExerciseList_Previews: PreviewProvider {
    static var previews: some View {
        let migrator = Migrator()
        Group {
            ViewExerciseList(withCategory: true, shouldHideButton: .constant(true), programmingExercise: false).environmentObject(GymViewModel())
            
            ViewExerciseList(withCategory: false, shouldHideButton: .constant(true), programmingExercise: true).environmentObject(GymViewModel())
            ViewExerciseList(withCategory: false, shouldHideButton: .constant(true), programmingExercise: false).environmentObject(GymViewModel())
            
        }
    }
}

