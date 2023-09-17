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
    var exercise:Exercise
    var reps:[RepsGraphData]
    var weight:[WeightGraphData]
    
    
    
    
    let catData = GymModel.repsExample
    let dogData = GymModel.weightExample
        let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.4),
                                                                        Color.accentColor.opacity(0)]),
                                            startPoint: .top,
                                            endPoint: .bottom)
    
    
    
    
    
    var dataReps: (name: String, repData: [RepsGraphData])  {(name: "Reps", repData:reps)}
    
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 30,height: 5)
                .foregroundColor(Color("LightGrayColor"))
                .padding(.top,10)
            
            
            Text(exercise.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom,50)
            
            Chart {
                        ForEach(catData) { data in
                            LineMark(x: .value("Date",  data.date),
                                     y: .value("Population", data.countReps))
                        }
                        .interpolationMethod(.cardinal)
                        .symbol(by: .value("Pet type", "cat"))

                        ForEach(catData) { data in
                            AreaMark(x: .value("Year", data.date),
                                     y: .value("Population", data.countReps))
                        }
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(linearGradient)
                    }
            .padding()
            .frame(width:viewModel.screenWidth,height:400)
            
            Spacer()
            
        }
        .frame(width: viewModel.screenWidth,height: viewModel.screenHeight)
        .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
            Color.clear
                .frame(height: 80)
                .background(Material.bar)
        }
        .background(Color.white.edgesIgnoringSafeArea(.top))
        .onTapGesture {
            viewModel.willAppearStatisticView.toggle()
            viewModel.selectedExerciseForStatisticView = nil
        }
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
        
        let weightData = [WeightGraphData(nameOfExercise: exercise.name, weight: 10, date: Date())]
        let repsData = [RepsGraphData(nameOfExercise: exercise.name, countReps: 10, date: Date())]
        StatistisView(exercise: exercise,reps:repsData, weight:weightData).environmentObject(GymViewModel())
    }
}
