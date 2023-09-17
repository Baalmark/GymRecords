//
//  GraphsModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 17.09.2023.
//

import Foundation
import Charts



struct RepsGraphData: Identifiable, Equatable {
    
    let nameOfExercise:String
    let countReps:Double
    let date:Date
    
    var id: String {  toStringDate(date: date) }
    
    
    func toStringDate(date:Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "y/M/d"
        return dateFormater.string(from: date)
    }
    
}

struct WeightGraphData: Identifiable, Equatable {
    
    
    let nameOfExercise:String
    let weight:Double
    let date:Date
    var id: String { toStringDate(date: date) }
    
    func toStringDate(date:Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "y/M/d"
        return dateFormater.string(from: date)
    }
    
    

}
