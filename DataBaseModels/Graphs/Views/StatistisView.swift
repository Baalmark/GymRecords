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
    var statisticViewModel:StatisticViewModel = StatisticViewModel()
    @State var dataForCharts:([RepsData],[WeightData]) = ([],[])
    @State private var selectedPeriod = "Week"

    let period = ["Week", "Month", "Year"]
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
            
            Picker("Appearance", selection: $selectedPeriod) {
                ForEach(period, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding([.bottom,.leading,.trailing])
            ScrollView {

                ChartsView(reps:reps,weight:weight)

            }
            .onAppear {
                viewModel.selectPeriodForCharts(period: selectedPeriod)
                viewModel.selectedExerciseForStatisticView = exercise
            }
            .onChange(of: selectedPeriod) { newValue in
                viewModel.selectPeriodForCharts(period: newValue)
            }
            
        }
        .padding()
        .frame(width: viewModel.screenWidth,height: viewModel.screenHeight)
        
        .background(Color.white.edgesIgnoringSafeArea(.top))
//                .onTapGesture {
//                    viewModel.willAppearStatisticView.toggle()
//                    viewModel.selectedExerciseForStatisticView = nil
//                }
    }
    
}

struct StatistisView_Previews: PreviewProvider {
    
    static var previews: some View {
        let migrator = Migrator()
        
        let viewModel = GymViewModel()
        
        let date1 = Date(timeIntervalSinceNow: -1 * 24 * 3600)
        let date2 = Date(timeIntervalSinceNow: -2 * 24 * 3600)
        let date3 = Date(timeIntervalSinceNow: -3 * 24 * 3600)
        let date4 = Date(timeIntervalSinceNow: -4 * 24 * 3600)
        let date5 = Date(timeIntervalSinceNow: -5 * 24 * 3600)
        let date6 = Date(timeIntervalSinceNow: -6 * 24 * 3600)
        let date7 = Date(timeIntervalSinceNow: -7 * 24 * 3600)
        
        let exercise = Exercise(type: .arms, name: "Biceps Curl", doubleWeight: true, selfWeight: false, isSelected: false, sets: [
            Sets(number: 1, date: date1, weight: 12, reps: 5, doubleWeight: true, selfWeight: false),
            Sets(number: 2, date: date2, weight: 10, reps: 1, doubleWeight: true, selfWeight: false),
            Sets(number: 3, date: date3, weight: 10, reps: 5, doubleWeight: true, selfWeight: false),
            Sets(number: 4, date: date4, weight: 10, reps: 4, doubleWeight: true, selfWeight: false),
            Sets(number: 5, date: date5, weight: 10, reps: 3, doubleWeight: true, selfWeight: false),
            Sets(number: 6, date: date6, weight: 10, reps: 3, doubleWeight: true, selfWeight: false),
            Sets(number: 7, date: date7, weight: 10, reps: 1, doubleWeight: true, selfWeight: false)], isSelectedToAddSet: false)
        
        let weightData = [WeightData(day: Date(), weight: 10)]
        let repsData = [RepsData(day: Date(),reps: 10)]
        StatistisView(exercise: exercise,reps:repsData, weight:weightData).environmentObject(viewModel)
    }
}


