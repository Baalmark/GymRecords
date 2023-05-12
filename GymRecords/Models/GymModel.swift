//
//  GymModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 14.01.2023.
//

import Foundation

//MARK: GymModel Struct
struct GymModel {
    
    
    var programs:[Program]
    var typesExercises:[TypeOfExercise] = TypeOfExercise.allExercises
    var arrayOfExercises:[Exercise] = arrayOfAllCreatedExercises
    var arrayOfPlannedTrainings:[TrainingInfo]
    var trainingDictionary:Dictionary<String,Program>
    
    init() {
        self.programs = [Program(programTitle: "Test", description: "TestDescription", colorDesign: "red", exercises: Program.exercises)]
        self.arrayOfPlannedTrainings = []
        trainingDictionary = [:]
    }
    //MARK: Program Struct
    struct Program:Identifiable {
        
        var id = UUID()
        var programTitle: String
        var description: String
        var colorDesign: String
        var exercises:[Exercise]
        
        //MARK: PROGRAM Functions
        
        
        //Create new Exercise
        mutating func createNewExercise(type t: GymModel.TypeOfExercise,title name: String,doubleWeight dB:Bool,selfWeight sW:Bool ) {
            exercises.append(Exercise(type: t, name: name, doubleWeight: dB, selfWeight: sW,isSelected: false, sets: [], isSelectedToAddSet: false))
        }
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
        case find = ""
        
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
            case 9: self = .find
            default: return nil
            }
        }
        
        
    }
    //MARK: Selected Exercises
    
    struct SelectedExercises:Hashable,Identifiable,Equatable {
        var id = UUID()
        var title:String
        var type:GymModel.TypeOfExercise
        
    }
    
    //MARK: Training
    
    struct TrainingInfo {
        var arrayOfExercises:[Exercise]
        var Date:Date
        
    }
    
    
    //MARK: Data of Profile
    struct ProfileData {
        
        var name: String
        var age: Int
        var weight: Int
        var height: Int
        var customProgramms:[Program]
    }
    
    
//MARK: MAIN Functions
    mutating func createNewProgram(title name:String,exercises exs:[Exercise],color cDesign:String,description desc:String) {
        programs.append(Program(programTitle: name, description: desc, colorDesign: cDesign, exercises: exs))
        
    }
    mutating func AddNewExercise(type:TypeOfExercise,title:String,doubleW db:Bool,selfW sw:Bool) {
        arrayOfExercises.append(Exercise(type: type, name: title, doubleWeight: db, selfWeight: sw,isSelected: false, sets: [], isSelectedToAddSet: false))
        
    }
    
    mutating func selectingExercise(exercise ex:Exercise,toggle:Bool) -> [Exercise] {
        
        
        for (index,elements) in arrayOfExercises.enumerated() {
            if elements.name == ex.name {
                
                arrayOfExercises[index] = ex
            }
        }
        return arrayOfExercises
    }
    func findNumberOfSelectedExerciseByType(type:TypeOfExercise,array:Array<Exercise>) -> Int {
        var result = 0
        
        for element in array {
            if element.type == type, element.isSelected == true {
                result += 1
            }
        }
        return result
    }
    func findNumberOfExerciseOneType(type:TypeOfExercise,array:Array<Exercise>) -> Int {
        var result = 0
        
        for element in array {
            if element.type == type{
                result += 1
            }
        }
        return result
    }
    
    //Toggle Double Weight marker
    func modelToggleBodyAndDoubleWeight(exercise:Exercise,bodyWeight:Bool,doubleWeight:Bool) -> Exercise {
        exercise.doubleWeight = doubleWeight
        exercise.selfWeight = bodyWeight
        return exercise
    }
    
    // Replace exercise in array of Exercise
    func replaceExerciseInArray(exercise:Exercise,array:[Exercise]) -> [Exercise] {
        var newArray = array
        for (i,elem) in array.enumerated() {
            if elem.name == exercise.name {
                newArray[i] = exercise
            }
        }
        return newArray
    }
    //Remove some exercise from arrayOfExercise
    func removeSomeExerciseFromArray(exercise:Exercise,array:[Exercise]) -> [Exercise] {
        var newArray = array
        for (i,element) in newArray.enumerated() {
            if element == exercise {
                newArray.remove(at: i)
            }
        }
        return newArray
    }
    //Create new Exercise to arrayOfExercise by User
        func createNewExercise(exercise:Exercise,array:[Exercise]) -> [Exercise] {
            var newArray = array
            newArray.append(exercise)
            return newArray
        }
    //Reload data to DataBase info title
    func reloadDataBaseInfo(trainDictionary: [String:GymModel.Program],progArray:[Program],arrayExercises:[Exercise]) -> [(String, Int)] {
        return [("WorkOut",trainDictionary.count),("Programms",progArray.count),("Exercises",arrayExercises.count)]
    }
    
    //Add program
    mutating func addProgram(_ program:Program) {
            programs.append(program)
    }
    
    //Remove program
    mutating func removeProgram(_ index:Int) {
            programs.remove(at: index)
        }
    //Find exercises by find textfield
    func finderByTextField(letters:String,array:Array<Exercise>) -> Array<Exercise> {
        
        var newArray:[Exercise] = []
        
        for element in array {
            if element.name.lowercased().contains(letters.lowercased()) {
                
                newArray.append(element)
            }
        }
        return newArray
    }
}


class Exercise:Equatable,Identifiable {
    
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        if lhs.name == rhs.name {
            return true
        }
        return false
    }
    
    
    var type: GymModel.TypeOfExercise
    var name: String
    var doubleWeight:Bool
    var selfWeight:Bool
    var isSelected:Bool
    var sets:[Sets]
    var isSelectedToAddSet:Bool
    init(type: GymModel.TypeOfExercise, name: String, doubleWeight: Bool, selfWeight: Bool, isSelected: Bool,sets:[Sets],isSelectedToAddSet:Bool) {
        self.type = type
        self.name = name
        self.doubleWeight = doubleWeight
        self.selfWeight = selfWeight
        self.isSelected = isSelected
        self.sets = sets
        self.isSelectedToAddSet = isSelectedToAddSet
    }
    
}

struct Sets: Identifiable {
    var id = UUID()
    var number: Int
    var date:Date
    var weight:Double
    var reps:Double
    var doubleWeight:Bool
    var selfWeight:Bool
    
    init(id: UUID = UUID(), number: Int, date:Date = Date(), weight: Double, reps: Double, doubleWeight: Bool, selfWeight: Bool) {
        self.id = id
        self.number = number
        self.date = date
        self.weight = weight
        self.reps = reps
        self.doubleWeight = doubleWeight
        self.selfWeight = selfWeight
    }
}


enum CalendarMinimizingPosition:CGFloat {
    
    
    case zero = 100000
    case first = 5
    case second = 2.5
    case third = 1.675
    case fourth = 1.26
    case fifth = 1
    
    
    
    
    init?(id : Int) {
        switch id {
        case 0: self = .zero
        case 1: self = .first
        case 2: self = .second
        case 3: self = .third
        case 4: self = .fourth
        case 5: self = .fifth
        default: return nil
        }
        
        
    }
   
}
    





//MARK: Extensions

extension GymModel {
    static var colors = ["green","red","cyan","purple","yellow","gray","blue","orange","pink","indigo","teal"]
    
}

extension GymModel.TypeOfExercise{
    
    
    static var allExercises:[GymModel.TypeOfExercise] = [.arms,.stretching,.legs,.back,.chest,.body,.shoulders,.cardio]
}

extension GymModel {
    static var arrayOfAllCreatedExercises = [Exercise(type: .cardio, name: "Running", doubleWeight: false, selfWeight: true,isSelected: false, sets: testSets, isSelectedToAddSet: false),
                                             Exercise(type: .cardio, name: "Cycling", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
                                             Exercise(type: .cardio, name: "Elips", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
                                             Exercise(type: .cardio, name: "Berpi", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
                                             Exercise(type: .cardio, name: "WorkOut", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
                                             Exercise(type: .arms, name: "Dumbbell Concentration Curl", doubleWeight: false, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
                                             Exercise(type: .arms, name: "Dumbbell Hammers Curl", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
                                             Exercise(type: .arms, name: "Biceps Curl", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
                                             Exercise(type: .chest, name: "Dumbbell bench press", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
                                             Exercise(type: .chest, name: "Push ups", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false)]
    
    static var testSets = [Sets(number: 1, weight: 75, reps: 2, doubleWeight: false, selfWeight: true),Sets(number: 2, weight: 75, reps: 2, doubleWeight: false, selfWeight: true)]
    static var doubleWeightAlertText = "For exercises with two projectiles (for example, with two dumbbells) specify the weight of only one projectile, then the tonnage statistics will be doubled and calculated correctly"
    
    static var bodyWeightAlertText = "For exercises with own weight (e.g. push-ups) instead of tonnage statistics will be displayed repetition statistics. If necessary, you can record the weight of the additional weight or leave the field empty"
}


extension GymModel.Program {
    static var exercises = GymModel.arrayOfAllCreatedExercises
}
