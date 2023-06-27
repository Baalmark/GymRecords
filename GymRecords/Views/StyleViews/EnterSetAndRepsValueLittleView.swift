//
//  EnterSetAndRepsValueLittleView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 16.05.2023.
//

import SwiftUI

struct EnterSetAndRepsValueLittleView: View {
    @EnvironmentObject var viewModel:GymViewModel
    var exercise:Exercise
    var screenWidth = UIScreen.main.bounds.width
    var isActiveView:Bool
    @State var notSavedSets:[Sets] = []
    @State var number:Int = 1
    @State var lastSet:Sets = Sets(number: 1, weight: 0, reps: 0, doubleWeight: false, selfWeight: false)
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
            if exercise.sets.isEmpty {
                EnterOrChangeOneCertainView(weight: lastSet.weight, reps: lastSet.reps, onSet: lastSet).onAppear() {
                    
                }
                .onChange(of: lastSet) { newValue in
                    
                    viewModel.changeValueToExercise(exercise: exercise, sets: lastSet, weight: lastSet.weight, reps: lastSet.reps)
                }
            } else {
                ForEach(exercise.sets) { onSet in
                    
                    EnterOrChangeOneCertainView(weight: onSet.weight, reps: onSet.reps, onSet: onSet).onAppear() {
                        if onSet.number == exercise.sets.count {
                            lastSet = onSet
                            lastSet.number += 1
                            testFlag = toAddSet
                            viewModel.newSets.append(onSet)
                        }
                        
                    }
                    .onChange(of: onSet) { newValue in
                        
                        viewModel.changeValueToExercise(exercise: exercise, sets: lastSet, weight: lastSet.weight, reps: lastSet.reps)
                    }
                }
            }
            if testFlag {
                EnterOrChangeOneCertainView(weight: lastSet.weight, reps: lastSet.reps, onSet: lastSet)
                    .onAppear {
                        
                        viewModel.newSets.append(lastSet)
                    }
            }
            
            AddSetLittleView(number: number)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        
                        var newSet = lastSet
                        newSet.number += 1
                        exercise.sets.append(newSet)
                        viewModel.newSets = exercise.sets
                    }
                }
            
            
        }
        .frame(width: viewModel.screenWidth)
    }
        .onAppear() {
            if testFlag && lastSet.weight != 0 && lastSet.reps != 0 {
                viewModel.newSets = exercise.sets
                viewModel.newSets.append(lastSet)
                }
        }
        }
        
        
    var inActiveView: some View {
        
        ForEach(exercise.sets) { onSet in
            EnterOrChangeOneCertainView(weight: onSet.weight, reps: onSet.reps, onSet: onSet)
                
            }
        
        
       
        
    }
}

struct EnterSetAndRepsValueLittleView_Previews: PreviewProvider {
    static var previews: some View {
        EnterSetAndRepsValueLittleView(exercise: GymModel.arrayOfAllCreatedExercises[0],isActiveView: false, toAddSet: true).environmentObject(GymViewModel())
    }
}
