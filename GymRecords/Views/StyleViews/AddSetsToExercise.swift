//
//  AddSetsToExercise.swift
//  GymRecords
//
//  Created by Pavel Goldman on 12.05.2023.
//

import SwiftUI

struct AddSetsToExercise: View {
    @EnvironmentObject var viewModel:GymViewModel
    
    var exercise:Exercise
    var body: some View {
        
        if exercise.sets.isEmpty {
            HStack {
                Text("1")
                    .font(.callout)
                
                    .foregroundColor(Color("LightGrayColor"))
                    .padding(.trailing,25)
                    .padding(.leading,15)
                HStack {
                    Text("0")
                        .frame(width: 145,height: 40)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color("LightGrayColor")))
                    Text("0")
                        .frame(width: 145,height: 40)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color("LightGrayColor")))
                }
            }
            .fontWeight(.bold)
            .frame(width: viewModel.screenWidth,height: 40)
            
        } else {
            ForEach(exercise.sets, id: \.id) { newSet in
                if viewModel.sameDateCheck(date1: viewModel.selectedDate, date2: newSet.date) {
                    HStack {
                    Text("\(newSet.number)")
                        .font(.callout)
                    
                        .foregroundColor(Color("LightGrayColor"))
                        .padding(.trailing,25)
                        .padding(.leading,15)
                    HStack {
                        Text("\(newSet.weight.formatted())")
                            .frame(width: 145,height: 40)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(Color("LightGrayColor")))
                        Text("\(newSet.reps.formatted())")
                            .frame(width: 145,height: 40)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(Color("LightGrayColor")))
                    }
                }
                    .fontWeight(.bold)
                    .frame(width: viewModel.screenWidth,height: 40)
            }
        }
        }
    }
    
    
    
}

struct AddSetsToExercise_Previews: PreviewProvider {
    static var previews: some View {
        AddSetsToExercise(exercise: .init(type: .arms, name: "DumbBell Ups", doubleWeight: true, selfWeight: false, isSelected: false, sets: [.init(number: 1, date: Date(), weight: 25, reps: 25, doubleWeight: true, selfWeight: false)], isSelectedToAddSet: true)).environmentObject(GymViewModel())
    }
}
