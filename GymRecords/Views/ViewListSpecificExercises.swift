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
    @State var exercise:Exercise = Exercise(type: .cardio, name: "Running", doubleWeight: false, selfWeight: true, isSelected: false)
    
    @State var exerciseProgramming:Bool
    var body: some View {
        ZStack {
            VStack(alignment:.leading){
                //Title and Button Create Exercise
                Text("\(typeOfExercise.rawValue.capitalized)")
                    .padding([.leading,.top],30)
                    .font(.custom("Helvetica", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(exerciseProgramming ? .white : .black)
                // Exercise Button
                ButtonCreateExercise(showCreateExercise: $showCreateExercise).opacity(!exerciseProgramming ? 1 : 0).disabled(exerciseProgramming)
                VStack{
                    
                    ForEach(viewModel.arrayExercises.indices,id:\.self) { id in
                        if viewModel.arrayExercises[id].type == typeOfExercise {
                            if viewModel.changeExercisesDB == false{
                                HStack {
                                    ExerciseToggle(exercise:viewModel.arrayExercises[id],
                                                   toggle: viewModel.arrayExercises[id].isSelected,
                                                   darkMode: exerciseProgramming)
                                }
                                .foregroundColor(exerciseProgramming ? .white : .black)
                                .padding([.leading,.trailing],30)
                                .padding(.top,30)
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
                .fullScreenCover(isPresented:$isChangeSheet) {
                    ChangeExerciseNameOrDeleteView(exercise: $exercise)
                }
                Spacer()
                
                //Button back to ExerciseViewList
                Button{
                    
                    viewModel.selectedCounterLabel = viewModel.computeSelectedCounderLabel()
                    
                    if viewModel.selectedExArray.isEmpty {
                        viewModel.isSelectedSomeExercise = false
                    } else {
                        viewModel.isSelectedSomeExercise = true
                    }
                    
                    
                    dismiss()
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
                
                .onChange(of: viewModel.selectedExArray.count) { elem in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.backButtonLabel = "\(viewModel.selectedExArray.count == 0 ? "" : "Selected: \(elem)  ")"
                    }}
                
                
            }
            .background(exerciseProgramming ? Color("backgroundDarkColor") : .white)
            .interactiveDismissDisabled()
            
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
        ViewListSpecificExercises(
            typeOfExercise: .arms, isPresented: .constant(true),
            exercise: Exercise(type: .chest, name: "Push ups",
                               doubleWeight: false, selfWeight: true,
                               isSelected: true), exerciseProgramming: true)
        .environmentObject(GymViewModel())
    }
}
