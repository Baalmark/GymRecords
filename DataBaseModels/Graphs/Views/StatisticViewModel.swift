//
//  StatisticViewModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 19.09.2023.
//

import SwiftUI

class StatisticViewModel {
    //MARK: Get last period of days statistic
    // -> [(Date,Sets)]
    func getlastPeriod(exercise:Exercise,period:Int) -> ([RepsData],[WeightData]) {
        var result:([RepsData],[WeightData]) = ([],[])
        // Iterate by 1 day
        let dayDurationInSeconds: TimeInterval = 60*60*24
        let now:Date = Date().addingTimeInterval(dayDurationInSeconds)
        let startPoint = now.addingTimeInterval(-(Double(period) * 24.0 * 3600))
        
        
        for date in stride(from: startPoint, to: now, by: dayDurationInSeconds) {
            let dataOfSets = summaryOfSetsInOneDay(date: date, allSets: exercise.sets)
            if dataOfSets.0 != 0 && dataOfSets.1 != 0 {
                let newObjectReps = RepsData(day: date, reps: dataOfSets.0)
                let newObjectWeights = WeightData(day: date, weight: dataOfSets.1)
                result.0.append(newObjectReps)
                result.1.append(newObjectWeights)
            }
        }
        return result
    }
    
    func summaryOfSetsInOneDay(date:Date,allSets:[Sets]) -> (Double,Double) {
        
        let filteredSets = allSets.filter {
            $0.date.hasSame(.day, as: date) && $0.date.hasSame(.month, as: date) && $0.date.hasSame(.year, as: date)
        }
        var reps:Double = 0
        var weights:Double = 0
        for nSet in filteredSets {
            reps += nSet.reps
            weights += nSet.weight
        }
        return (reps,weights)
    }
    
    
    
}
