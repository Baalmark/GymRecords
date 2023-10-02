//
//  ExercisesAndProgrammsListView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 09.02.2023.
//

import SwiftUI

struct ExercisesAndProgramsListView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var mainNavigationSelector:Bool = false
    @State private var contentSize: CGSize = .zero
    @EnvironmentObject var viewModel:GymViewModel
    @State private var didTap:Bool = false
    @State private var exercisePos = 0
    @State private var programmPos = GymViewModel().screenWidth
    @State var shouldHideButton:Bool = true
    @State var createExericseWithCategory = false
    
    var body: some View {
        VStack{
            HStack(spacing:20){
                Button{
                    //If exercises button hasn't tapped yet
                    if didTap == true {
                        
                        withAnimation(.spring()){
                            didTap.toggle()
                            viewModel.clearSelectedExArray()
                            viewModel.isSearching = true
                        }
                        
                        
                    }
                } label: {
                    Text("Exercises")
                        .foregroundColor(didTap ? .gray : .white)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(width: viewModel.constW(w:125),height: viewModel.constH(h:35))
                .padding([.leading,.trailing],25)
                .padding([.top,.bottom],10)
                
                .background(Rectangle()
                    .foregroundColor(didTap ? .white : Color("backgroundDarkColor"))
                    .cornerRadius(10)
                )
                Button{
                    
                    //If programms button hasn't tapped yet
                    if didTap == false {
                        withAnimation(.spring()){
                            didTap.toggle()
                            viewModel.clearSelectedExArray()
                            viewModel.isSearching = false
                        }
                    }
                    
                    
                } label: {
                    Text("Programs")
                        .foregroundColor(didTap ? .white : .gray)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(width: viewModel.constW(w:125),height: viewModel.constH(h:35))
                .padding([.leading,.trailing],25)
                .padding([.top,.bottom],10)
                
                
                .background(Rectangle()
                    .foregroundColor(didTap ? Color("backgroundDarkColor") : .white)
                    .cornerRadius(10)
                )
            }
            
            
            // List of types Execises, Tappable, it has behavior like Navitation Link
            if !didTap {
                ScrollView {
                    ButtonCreateExercise(showCreateExercise: $createExericseWithCategory)
                        
                    if viewModel.searchWord.isEmpty {
                        ViewExerciseList(withCategory: true, shouldHideButton: $viewModel.isSelectedSomeExercise, programmingExercise: false)
//                            .environmentObject(viewModel)
                            .overlay(
                                GeometryReader { geo in
                                    Color.clear.onAppear {
                                        contentSize = geo.size
                                    }
                                }
                            )
                            .frame(width: viewModel.screenWidth,height: 600)
                            .padding(.top,-20)
                            .transition(.move(edge: .leading))
                        
                        
                    } else {
                        ViewListSpecificExercises(typeOfExercise: .find, isPresented: $viewModel.isShowedViewListSpecificExercise, exerciseProgramming: false)
//                            .environmentObject(viewModel)
                            
                    }
                }
                .frame(maxWidth: contentSize.width, maxHeight: contentSize.height)
                .transition(.move(edge: .leading))
                Button("Ready") {
                    viewModel.createTraining(date: viewModel.selectedDate, exercises: viewModel.selectedExArray)
                    viewModel.unSelectingEx(array: viewModel.arrayExercises)
                    viewModel.selectedExArray = []
                    viewModel.selectedCounterLabel = []
                    viewModel.backButtonLabel = ""
                    
                    dismiss()
                    
                }.buttonStyle(GrowingButton(isDarkMode: false,width: viewModel.constW(w:335),height: viewModel.constH(h:45)))
                    .tint(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .offset(x:0,y:viewModel.constH(h:-20))
                    .opacity(viewModel.selectedExArray.isEmpty ? 0 : 1)
                
            } else {
                ViewProgramsList()
                    .transition(.move(edge: .trailing))
            }
        }
        .fullScreenCover(isPresented: $createExericseWithCategory) {
            ViewExerciseList(withCategory: false, shouldHideButton: $viewModel.isSelectedSomeExercise, programmingExercise: false)
//          .environmentObject(viewModel)
        }
        
        
    }
}


struct ExercisesAndProgrammsListView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()

        ExercisesAndProgramsListView().environmentObject(GymViewModel())
    }
}
