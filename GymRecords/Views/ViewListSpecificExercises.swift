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
    @Binding var backButtonLabel:String
    @State var toggleArrayCounter = 0
    @Binding var toggleArray:[Exercise]
    @State var typeOfExercise:GymModel.TypeOfExercise
    @Binding var isPresented: Bool
    @State var isTappedToggle = false
    @Binding var selectedExerciseArray:[Int]
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
                if exerciseProgramming == false {
                    ButtonCreateExercise(showCreateExercise: $showCreateExercise)
                }
                VStack{
                    
                    ForEach(viewModel.arrayExercises.indices,id:\.self) { id in
                        if viewModel.arrayExercises[id].type == typeOfExercise {
                            if viewModel.changeExercisesDB == false{
                                HStack {
                                    ExerciseToggle(exercise:viewModel.arrayExercises[id],
                                                   toggle: viewModel.arrayExercises[id].isSelected,
                                                   toggleArray: $toggleArray,
                                                   toggleArrayCounter: $toggleArrayCounter,
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
                    
                    selectedExerciseArray = viewModel.selectedCounterLabel
                    
                    if viewModel.selectedExArray.isEmpty {
                        viewModel.isSelectedSomeExercise = false
                    } else {
                        viewModel.isSelectedSomeExercise = true
                    }
                    
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text(self.backButtonLabel)
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
                
                .onChange(of: self.toggleArrayCounter) { elem in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.backButtonLabel = "\(self.toggleArrayCounter == 0 ? "" : "Selected: \(elem)  ")"
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
    @Binding var toggleArray:[Exercise]
    @Binding var toggleArrayCounter:Int
    var darkMode:Bool
        var body: some View {
            VStack(spacing: 0) {
                Toggle(exercise.name, isOn: $toggle)
                    .font(.custom("Helvetica",size: 22))
                    .fontWeight(.bold)
                    .onChange(of: toggle) { elem in
                        
                        if elem == true {
                            
                            print("Im goin to true")
                            viewModel.selectingExercise(exercise: exercise, isSelected: toggle)
                            toggleArrayCounter = viewModel.selectedExArray.count
                            toggleArray = viewModel.selectedExArray
                            
                            
                        } else {
                            
                            print("Im to false")
                            viewModel.unselectingExercise(exercise: exercise, isSelected: toggle)
                            toggleArrayCounter = viewModel.selectedExArray.count
                            toggleArray = viewModel.selectedExArray
                            
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
        ViewListSpecificExercises(backButtonLabel: .constant(""),
                                  toggleArray: .constant([Exercise(type: .chest, name: "Push ups",
                                                                   doubleWeight: false, selfWeight: true,
                                                                   isSelected: true)]),typeOfExercise: .cardio,
                                  isPresented: .constant(true),
                                  selectedExerciseArray: .constant([]),
                                  exercise: Exercise(type: .chest, name: "Push ups",
                                                     doubleWeight: false, selfWeight: true,
                                                     isSelected: true), exerciseProgramming: false)
        .environmentObject(GymViewModel())
    }
}
