//
//  ViewListSpecificExercises.swift
//  GymRecords
//
//  Created by Pavel Goldman on 01.02.2023.
//

import SwiftUI

struct ViewListSpecificExercises: View {
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @State var toggleArrayCounter = 0
    @State var typeOfExercise:GymModel.TypeOfExercise
    @Binding var isPresented: Bool
    @State var isTappedToggle = false
    @State var showCreateExercise = false
    @State var isChangeSheet = false
    @State var exercise:Exercise = Exercise(type: .cardio, name: "Running", doubleWeight: false, selfWeight: true, isSelected: false, sets: [], isSelectedToAddSet: false)
    @State var exerciseProgramming:Bool
    var body: some View {
        ZStack {
            VStack(alignment:.leading){
                if viewModel.searchWord.isEmpty {
                    //Title and Button Create Exercise
                    Text("\(typeOfExercise.rawValue.capitalized)")
                        .padding([.leading,.top],30)
                        .font(.custom("Helvetica", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(exerciseProgramming ? .white : .black)
                        .opacity(!viewModel.searchWord.isEmpty ? 0 : 1)
                    // Exercise Button
                    ButtonCreateExercise(showCreateExercise: $viewModel.isShowedCreateExView)
                        .opacity(!exerciseProgramming ? 1 : 0)
                        .disabled(exerciseProgramming)
                }
                    
                VStack{
                    if !viewModel.arrayOfFoundExercise.isEmpty {
                        ForEach(viewModel.arrayOfFoundExercise.indices,id:\.self) { id in
                            if viewModel.changeExercisesDB == false{
                                HStack {
                                    ExerciseToggle(exercise:viewModel.arrayOfFoundExercise[id],
                                                   toggle: viewModel.arrayOfFoundExercise[id].isSelected,
                                                   darkMode: exerciseProgramming)
                                }
                                .foregroundColor(exerciseProgramming ? .white : .black)
                                .padding([.leading,.trailing],30)
                                .padding(.top,30)
                            } else {
                                HStack {
                                    Text(viewModel.arrayOfFoundExercise[id].name)
                                        .font(.custom("Helvetica", size: 22))
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding(.bottom,20)
                                .padding([.leading,.trailing],30)
                                .padding(.top,20)
                                .onTapGesture{
                                    exercise = viewModel.arrayOfFoundExercise[id]
                                    UIView.setAnimationsEnabled(true)    // << here !!
                                    isChangeSheet.toggle()
                                }
                            }
                        }
                        
                    } else {
                        ForEach(viewModel.arrayExercises.indices,id:\.self) { id in
                            
                                if viewModel.arrayExercises[id].type == typeOfExercise {
                                    if viewModel.changeExercisesDB == false{
                                        HStack {
                                            ExerciseToggle(exercise:viewModel.arrayExercises[id],
                                                           toggle: viewModel.arrayExercises[id].isSelected,
                                                           darkMode: exerciseProgramming)
                                        }
                                        .foregroundColor(exerciseProgramming ? .white : !viewModel.comprasionNameExerciseWithListAllExercises(name: viewModel.arrayExercises[id].name, exercises: viewModel.trainInSelectedDay.exercises) ? .black : .red )
                                        .padding([.leading,.trailing],30)
                                        .padding(.top,30)
                                        .disabled(viewModel.comprasionNameExerciseWithListAllExercises(name: viewModel.arrayExercises[id].name, exercises: viewModel.trainInSelectedDay.exercises))
                                        
                                    } else {
                                        HStack {
                                            Text(viewModel.arrayExercises[id].name)
                                                .font(.custom("Helvetica", size: 22))
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        .padding(.bottom,20)
                                        .padding([.leading,.trailing],30)
                                        .padding(.top,20)
                                        .onTapGesture{
                                            exercise = viewModel.arrayExercises[id]
                                            UIView.setAnimationsEnabled(true)    // << here !!
                                            isChangeSheet.toggle()
                                        }
                                    }
                                }
                            
                        }
                        
                    }
                    
                }
                .fullScreenCover(isPresented:$isChangeSheet) {
                    ChangeExerciseNameOrDeleteView(exercise: $exercise)
                }
                
                
                Spacer()
                
                //Button back to ExerciseViewList
                Button{
                    
                    withAnimation(.easeInOut) {
                        viewModel.isShowedViewListSpecificExercise.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text(viewModel.backButtonLabel)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica", size: 20))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .padding(10)
                }
                .font(.custom("Helvetica", size: 26))
                .foregroundColor(.white)
                
                .background(Capsule(style: .continuous))
                .foregroundColor(Color("MidGrayColor"))
                .padding(.bottom,40)
                .padding(.leading,30)
                .opacity(!viewModel.searchWord.isEmpty ? 0 : 1) // if client doesn't find certain exercise
                .disabled(!viewModel.searchWord.isEmpty)
                
                .onChange(of: viewModel.selectedExArray.count) { elem in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.backButtonLabel = "\(viewModel.selectedExArray.count == 0 ? "" : "Selected: \(elem)  ")"
                    }}
                
                
            }
            .background(exerciseProgramming ? Color("backgroundDarkColor") : .white)
            .interactiveDismissDisabled()
            
        }
        .overlay() {
            if viewModel.isShowedCreateExView {
                CreateNewExercise(typeOfExercise: typeOfExercise, isNoCategoryCreating: false)
            }
        }
        }
    }
    








//Toggle for every Exercise
struct ExerciseToggle: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    var exercise:Exercise
    @State var toggle:Bool
    var darkMode:Bool
    var body: some View {
        VStack(spacing: 0) {
            Toggle(exercise.name, isOn: $toggle)
                .font(.custom("Helvetica",size: 22))
                .fontWeight(.bold)
                .onChange(of: toggle) { elem in
                    if elem {
                        viewModel.selectingExercise(exercise: exercise, isSelected: toggle)
                    } else {
                        viewModel.unselectingExercise(exercise: exercise, isSelected: toggle)
                    }
                    viewModel.selectedCounterLabel = viewModel.computeSelectedCounderLabel()
                }
            
        }
        .toggleStyle(CheckboxStyle(darkMode: darkMode))
        .padding(.horizontal)
    }
}



//Toggle Style
struct CheckboxStyle: ToggleStyle {
    var darkMode:Bool
    func makeBody(configuration: Self.Configuration) -> some View {
        
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark" : "square.fill")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(darkMode ? (configuration.isOn ? .white : Color("backgroundDarkColor")) : (configuration.isOn ? .black : .white))
                .font(.custom("Helvetica", size: 22))
            
        }
        .onTapGesture { configuration.isOn.toggle()}
        
    }
}


struct ViewListSpecificExercises_Previews: PreviewProvider {
    static var previews: some View {
        let migrator = Migrator()
        Group {
            ViewListSpecificExercises(
                typeOfExercise: .arms, isPresented: .constant(true),
                exercise: Exercise(type: .chest, name: "Push ups",
                                   doubleWeight: false, selfWeight: true,
                                   isSelected: true, sets: [], isSelectedToAddSet: false), exerciseProgramming: true)
            
            ViewListSpecificExercises(
                typeOfExercise: .arms, isPresented: .constant(true),
                exercise: Exercise(type: .chest, name: "Push ups",
                                   doubleWeight: false, selfWeight: true,
                                   isSelected: true, sets: [], isSelectedToAddSet: false), exerciseProgramming: false)
        }
        .environmentObject(GymViewModel())
    }
}
