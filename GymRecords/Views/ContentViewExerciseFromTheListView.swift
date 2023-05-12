//
//  ContentViewExerciseFromTheListView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 12.05.2023.
//

import SwiftUI

struct ContentViewExerciseFromTheListView: View {
    @EnvironmentObject var viewModel:GymViewModel
    
    var exercise:Exercise
    
    var body: some View {
        HStack {
            
            Image(exercise.type.rawValue)
                .padding([.leading,.trailing], 10)
            Text(exercise.name.capitalized)
                .fontWeight(.bold)
                .font(.custom("Helvetica", size: 18))
            Spacer()
            Image(systemName: exercise.isSelectedToAddSet ? "chevron.up" : "chevron.down")
                .padding([.leading,.trailing], 10)
                .fontWeight(.medium)
                .font(.custom("Helvetica", size: 16))
            
        }
        
        
        
        .padding([.leading,.trailing],10)
    }
}

struct ContentViewExerciseFromTheListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewExerciseFromTheListView(exercise: .init(type: .arms, name: "Dumbbell Up", doubleWeight: true, selfWeight: false, isSelected: false, sets: [], isSelectedToAddSet: false)).environmentObject(GymViewModel())
    }
}
