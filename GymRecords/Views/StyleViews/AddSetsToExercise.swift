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
        //MARK: Advanced checker is any sets created before on selected date
        if !exercise.sets.contains(where: {
            viewModel.toStringDate(date: $0.date) == viewModel.toStringDate(date: viewModel.selectedDate)
        }){
            HStack {
                    Text("0")
                        .frame(width: 160,height: 40)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color("LightGrayColor")))
                        .padding(.trailing,5)
                    Text("0")
                        .frame(width: 160,height: 40)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color("LightGrayColor")))
                        .padding(.leading,5)
            }
            .fontWeight(.bold)
            .frame(width: viewModel.screenWidth,height: 40)
            
        } else {
            ForEach(exercise.sets, id: \.id) { newSet in
                if viewModel.sameDateCheck(date1: viewModel.selectedDate, date2: newSet.date) {
                    HStack {
                        Text("\(newSet.weight.formatted())")
                            .frame(width: 160,height: 40)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(Color("LightGrayColor")))
                            .padding(.trailing,5)
                        Text("\(newSet.reps.formatted())")
                            .frame(width: 160,height: 40)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(Color("LightGrayColor")))
                            .padding(.leading,5)
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
