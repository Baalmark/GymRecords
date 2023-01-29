//
//  GymModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 14.01.2023.
//

import Foundation

//MARK: GymModel Struct
struct GymModel {
    
    //    var Date: Date
    var programmTitle: Programm
    var programms:[Programm]?
    
    
    //MARK: Programm Struct
    struct Programm {
        
        var programmTitle: String
        var countOfExcercises: Int
        var description: String
        var colorDesign: String
        var exercises:[Exercise]?
        
        
    
//MARK: PROGRAMM Functions
        
        
        //Create new Exercise
        mutating func createNewExercise(type t: GymModel.typeOfExercise,title name: String,doubleWeight dB:Bool,selfWeight sW:Bool ) {
            exercises?.append(GymModel.Exercise(type: t, name: name, doubleWeight: dB, selfWeight: sW))
            
            
        }
    }
    //MARK: Exercise Struct
    struct Exercise {
        
        var type: typeOfExercise
        var name: String
        var doubleWeight:Bool
        var selfWeight:Bool
        
    }
    //MARK: type of execrice Enumeration
    enum typeOfExercise {
        
        case arms
        case legs
        case back
        case chest
        case body
        case shoulders
    }
    
    //MARK: Data of Profile
    struct ProfileData {
        
        var name: String
        var age: Int
        var weight: Int
        var height: Int
        var customProgramms:[Programm]
    }
    
    
//MARK: MAIN Functions
    mutating private func createNewProgramm(title name:String,exercises exs:[Exercise],color cDesign:String,description desc:String) {
        programms?.append(Programm(programmTitle: name, countOfExcercises: exs.count, description: desc, colorDesign: cDesign))
        
    }
    

    
}

//MARK: Extensions
extension GymModel.Programm {
    static var exercises = [GymModel.Exercise(type: GymModel.typeOfExercise.back, name: "Back",doubleWeight: false,selfWeight: false)]
}


extension GymModel {

    static var programms = Programm(programmTitle: "Test", countOfExcercises: 1, description: "TestDescription", colorDesign: "Black", exercises: Programm.exercises)
}

