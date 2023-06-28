//
//  EnterSetAndRepsValueLittleView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 16.05.2023.
//

import SwiftUI

struct EnterSetAndRepsValueLittleView: View {
    @EnvironmentObject var viewModel:GymViewModel
    @State var exercise:Exercise
    var screenWidth = UIScreen.main.bounds.width
    var isActiveView:Bool
    @State var notSavedSets:[Sets] = []
    @State var number:Int = 1
    @State var lastSet = Sets(number: 1, weight: 0, reps: 0, doubleWeight: false, selfWeight: false)
    @State var testFlag = false
    @State var toAddSet:Bool
    var body: some View {
        
        if isActiveView {
            activeView
            
        } else {
            inActiveView
        }
    }
    
    var activeView : some View {
        ScrollView {
        VStack {
            ForEach(exercise.sets) { onSet in
                EnterOrChangeOneCertainView(weight: onSet.weight, reps: onSet.reps, onSet: onSet, number: onSet.number, exercise: exercise)
                        .onChange(of: onSet) { newValue in
                            viewModel.changeValueToExercise(exercise: exercise, sets: newValue, weight: newValue.weight, reps: newValue.reps)
                        }
                        .onAppear {
                            if exercise.sets.isEmpty {
                                let newSet = Sets(number: 1, weight: 0, reps: 0, doubleWeight: exercise.doubleWeight, selfWeight: exercise.selfWeight)
                                lastSet = newSet
                                exercise.sets.append(newSet)
                            }
                }
            }
            
            AddSetLittleView(number: exercise.sets.count + 1)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        
                        exercise = viewModel.createSet(exercise: viewModel.crntExrcsFrEditSets)
                        viewModel.crntExrcsFrEditSets = exercise
                        }
                    }

        }
        .onAppear {
            if toAddSet {
                withAnimation(.easeInOut) {
                    
                    exercise = viewModel.createSet(exercise: viewModel.crntExrcsFrEditSets)
                    viewModel.crntExrcsFrEditSets = exercise
                    }
            }
        }
        .frame(width: viewModel.screenWidth)
    }
        .onAppear() {
            if exercise.sets.first?.reps != 0 || exercise.sets.first?.weight != 0 {
                viewModel.newSets = exercise.sets
                }
        }
        }
        
        
    var inActiveView: some View {
        
        ForEach(exercise.sets) { onSet in
            EnterOrChangeOneCertainView(weight: onSet.weight, reps: onSet.reps, onSet: onSet, number: onSet.number, exercise: exercise)
                .onChange(of: onSet) { newValue in
                    viewModel.changeValueToExercise(exercise: exercise, sets: newValue, weight: newValue.weight, reps: newValue.reps)
                }
            }
        
        
        
        
        
        
       
        
    }
}

struct EnterSetAndRepsValueLittleView_Previews: PreviewProvider {
    static var previews: some View {
        EnterSetAndRepsValueLittleView(exercise: GymModel.arrayOfAllCreatedExercises[0],isActiveView: true, toAddSet: true).environmentObject(GymViewModel())
    }
}
