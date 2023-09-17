//
//  GraphsViewModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 17.09.2023.
//

import SwiftUI

class GraphViewModel{
    
    var repsGraphData:RepsGraphData
    var weightGraphData:WeightGraphData
    let exercise:String
    
    init (exercise:String, repsOfSet:Double,weightOfSet:Double,dateOfSet:Date) {
        self.exercise = exercise
        
        self.repsGraphData = RepsGraphData(nameOfExercise: exercise, countReps: repsOfSet, date: dateOfSet )
        self.weightGraphData = WeightGraphData(nameOfExercise: exercise, weight: weightOfSet, date: dateOfSet)
        }
        
        
    }
    
    
