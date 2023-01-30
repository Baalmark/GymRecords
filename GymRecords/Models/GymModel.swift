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
    var typesExercises:[TypeOfExercise] = TypeOfExercise.allExercises
    
    //MARK: Programm Struct
    struct Programm {
        
        var programmTitle: String
        var countOfExcercises: Int
        var description: String
        var colorDesign: String
        var exercises:[Exercise]?
        
        
    
//MARK: PROGRAMM Functions
        
        
        //Create new Exercise
        mutating func createNewExercise(type t: GymModel.TypeOfExercise,title name: String,doubleWeight dB:Bool,selfWeight sW:Bool ) {
            exercises?.append(GymModel.Exercise(type: t, name: name, doubleWeight: dB, selfWeight: sW))
            
            
        }
    }
    //MARK: Exercise Struct
    struct Exercise {
        
        var type: TypeOfExercise
        var name: String
        var doubleWeight:Bool
        var selfWeight:Bool
        
    }
    //MARK: type of execrice Enumeration
    enum TypeOfExercise:String,CaseIterable,Identifiable {
        var id: String { return self.rawValue }
        
        case arms = "arms"
        case stretching = "stretching"
        case legs = "legs"
        case back = "back"
        case chest = "chest"
        case body = "body"
        case shoulders = "shoulders"
        case cardio = "cardio"
        
        init?(id : Int) {
            switch id {
            case 1: self = .arms
            case 2: self = .stretching
            case 3: self = .legs
            case 4: self = .back
            case 5: self = .chest
            case 6: self = .body
            case 7: self = .shoulders
            case 8: self = .cardio
            default: return nil
            }
        }
        
        
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
    static var exercises = [GymModel.Exercise(type: GymModel.TypeOfExercise.back, name: "Back",doubleWeight: false,selfWeight: false)]
}


extension GymModel {

    static var programms = Programm(programmTitle: "Test", countOfExcercises: 1, description: "TestDescription", colorDesign: "Black", exercises: Programm.exercises)
}

extension GymModel.TypeOfExercise{
    
    
    static let allExercises:[GymModel.TypeOfExercise] = [.arms,.stretching,.legs,.back,.chest,.body,.shoulders,.cardio]
}
