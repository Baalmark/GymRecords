//
//  DisplaySetsMainView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 02.07.2023.
//

import SwiftUI

struct DisplaySetsMainView: View {
    @EnvironmentObject var viewModel:GymViewModel
    
    var exercise:Exercise
    var width:CGFloat = 33.5
    var body: some View {
        
        ForEach(exercise.sets, id: \.id) { newSet in
            if viewModel.sameDateCheck(date1: viewModel.selectedDate, date2: newSet.date) {
                HStack {
                    Text("\(newSet.number)")
                        .padding(.leading,-15)
                        .font(.callout.bold())
                        .foregroundColor(Color("MidGrayColor"))
                    HStack {
                        Text("\(newSet.weight.formatted())")
                            .font(.custom("Helvetica", size: viewModel.constW(w:24)).bold())
                            .foregroundColor(.black)
                        
                            .multilineTextAlignment(.center)
                            .frame(width: viewModel.constW(w:viewModel.screenWidth / 2 - width),height: viewModel.constH(h:70))
                            .background(RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("LightGrayColor")))
                        Text("\(newSet.reps.formatted())")
                            .font(.custom("Helvetica", size: viewModel.constW(w:24)).bold())
                            .foregroundColor(.black)
                            .frame(width: viewModel.constW(w:viewModel.screenWidth / 2 - width),height: viewModel.constH(h:70))
                            .multilineTextAlignment(.center)
                            .background(RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("LightGrayColor")))
                    }
                }
                
                
                .frame(width: viewModel.constW(w:viewModel.screenWidth - 60),height: viewModel.constH(h:70))
            }
        }
        }
    }
    

struct DisplaySetsMainView_Previews: PreviewProvider {
    static var previews: some View {
        let migrator = Migrator()

        DisplaySetsMainView(exercise: .init(type: .arms, name: "DumbBell Ups", doubleWeight: true, selfWeight: false, isSelected: false, sets: [.init(number: 1, date: Date(), weight: 25, reps: 25, doubleWeight: true, selfWeight: false)], isSelectedToAddSet: true)).environmentObject(GymViewModel())
    }
}
