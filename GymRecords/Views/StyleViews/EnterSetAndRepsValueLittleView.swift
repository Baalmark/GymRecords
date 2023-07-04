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
    @State var notSavedSets:[Sets] = []
    @State var number:Int = 1
    @State var lastSet = Sets(number: 1, weight: 0, reps: 0, doubleWeight: false, selfWeight: false)

    @State var toAddSet:Bool
    var body: some View {
        activeView
    }
    
    var activeView : some View {
        ScrollView {
            VStack {
                ForEach(exercise.sets, id: \.id) { onSet in
                    EnterOrChangeOneCertainView(weight: onSet.weight, reps: onSet.reps, onSet: onSet, number: onSet.number, exercise: exercise)
                        
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
                            viewModel.setsBackUp = exercise.sets
                            
                            exercise = viewModel.createSet(exercise: viewModel.crntExrcsFrEditSets)
                            
                        }
                    }
                
            }
            .onAppear {
                if toAddSet {
                    withAnimation(.easeInOut) {
                        viewModel.setsBackUp = exercise.sets
                        exercise = viewModel.createSet(exercise: viewModel.crntExrcsFrEditSets)
                        
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
    
    
    
}

struct EnterSetAndRepsValueLittleView_Previews: PreviewProvider {
    static var previews: some View {
        EnterSetAndRepsValueLittleView(exercise: GymModel.arrayOfAllCreatedExercises[0], toAddSet: true).environmentObject(GymViewModel())
    }
}
