//
//  StatistisView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 17.09.2023.
//

import SwiftUI
import Charts
struct StatistisView: View {
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedTheme = "Dark"
    let themes = ["Dark", "Light", "Automatic"]
    
    var exercise:Exercise
    var reps:[RepsData]
    var weight:[WeightData]
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 30,height: 5)
                .foregroundColor(Color("LightGrayColor"))
                .padding(.top,10)
            
            
            Text(exercise.name)
                .font(.title)
                .fontWeight(.bold)
            
            Picker("Appearance", selection: $selectedTheme) {
                ForEach(themes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding([.bottom,.leading,.trailing])
            
            
            ScrollView {
                SingleLineLollipop(isOverview: true,reps:reps,weight:weight)
                
                
                Text("History")
                    .font(.largeTitle)
            }
            
        }
        .frame(width: viewModel.screenWidth,height: viewModel.screenHeight)
        
        .background(Color.white.edgesIgnoringSafeArea(.top))
        //        .onTapGesture {
        //            viewModel.willAppearStatisticView.toggle()
        //            viewModel.selectedExerciseForStatisticView = nil
        //        }
    }
    
}

struct StatistisView_Previews: PreviewProvider {
    
    static var previews: some View {
        let migrator = Migrator()
        
        let exercise = Exercise(type: .arms, name: "Biceps Curl", doubleWeight: true, selfWeight: false, isSelected: false, sets: [
            Sets(number: 1, date: Date(), weight: 10, reps: 5, doubleWeight: true, selfWeight: false),
            Sets(number: 2, date: Date(), weight: 10, reps: 5, doubleWeight: true, selfWeight: false),
            Sets(number: 3, date: Date(), weight: 10, reps: 5, doubleWeight: true, selfWeight: false),
            Sets(number: 4, date: Date(), weight: 10, reps: 5, doubleWeight: true, selfWeight: false),
            Sets(number: 5, date: Date(), weight: 10, reps: 5, doubleWeight: true, selfWeight: false),
            Sets(number: 6, date: Date(), weight: 10, reps: 5, doubleWeight: true, selfWeight: false)], isSelectedToAddSet: false)
        
        let weightData = [WeightData(day: Date(), weight: 10)]
        let repsData = [RepsData(day: Date(),reps: 10)]
        StatistisView(exercise: exercise,reps:repsData, weight:weightData).environmentObject(GymViewModel())
    }
}
