//
//  GymModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 14.01.2023.
//

import Foundation
import RealmSwift
//MARK: GymModel Struct
struct GymModel {
    
    var programs:[Program]
    var typesExercises:[TypeOfExercise] = TypeOfExercise.allExercises
    var arrayOfExercises:[Exercise]
    var trainingDictionary:Dictionary<String,Program> = [:]
    
    init(programs:[Program] = [],exercises:[Exercise] = GymModel.arrayOfAllCreatedExercises, trainingDictionary:Dictionary<String,Program> = [:]) {
        self.programs = []
        self.programs = GymModel.basicPrograms
        self.trainingDictionary = [:]
        self.arrayOfExercises = GymModel.arrayOfAllCreatedExercises

    }
    
    //MARK: Program Struct
    struct Program:Identifiable {
        
        var id = UUID()
        var numberOfProgram:Int
        var programTitle: String
        var programDescription: String
        var colorDesign: String
        var exercises:[Exercise]
    }
    
    //MARK: type of execrice Enumeration
    enum TypeOfExercise:String,CaseIterable,Identifiable {
        var id: String { return self.rawValue }
        
        case arms = "arms"
        case stretching = "stretching"
        case legs = "legs"
        case back = "back"
        case chest = "chest"
        case abs = "ABS"
        case shoulders = "shoulders"
        case cardio = "cardio"
        case find = ""
        
        init?(id : String) {
            switch id {
            case "arms": self = .arms
            case "stretching": self = .stretching
            case "legs": self = .legs
            case "back": self = .back
            case "chest": self = .chest
            case "ABS": self = .abs
            case "shoulders": self = .shoulders
            case "cardio": self = .cardio
            case "find": self = .find
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
    
    //MARK: Training info
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
    
    
    //MARK: Counters of exercises and selected  exercises
    func findNumberOfSelectedExerciseByType(type:TypeOfExercise,array:Array<Exercise>) -> Int {
        return array.filter({$0.type == type && $0.isSelected == true}).count
    }
    func findNumberOfExerciseOneType(type:TypeOfExercise,array:Array<Exercise>) -> Int {
        return array.filter({$0.type == type}).count
    }
    
    
    //MARK: Edit exercise in data base
    mutating func editExercise(newExercise:Exercise,oldExerciseName:String) {
        if let exerciseIndex = arrayOfExercises.firstIndex(where: {$0.name == oldExerciseName}) {
            arrayOfExercises[exerciseIndex] = newExercise
            DataLoader().changeExerciseRealm(exercise: newExercise, oldExerciseName: oldExerciseName)
        }
        
    }
    //MARK: Remove some exercise from arrayOfExercise
    func removeExFromArray(exercise:Exercise,array:[Exercise]) -> [Exercise] {
        var newArray = array
        if let exIndex = array.firstIndex(where: {$0 == exercise}) { newArray.remove(at: exIndex) }
        return newArray
    }
    //MARK: Create new Exercise to arrayOfExercise by User
    func createNewExercise(exercise:Exercise,array:[Exercise]) -> [Exercise] {
        var newArray = array
        newArray.append(exercise)
        return newArray
    }
    //MARK: Reload data to DataBase info title
    func reloadDataBaseInfo(trainDictionary: [String:GymModel.Program],progArray:[Program],arrayExercises:[Exercise]) -> [(String, Int)] {
        return [("WorkOut",DataLoader().returnCountOfTrainings()),("Programs",DataLoader().returnCountOfPrograms()),("Exercises",DataLoader().returnCountOfExercises())]
    }
    
    //MARK: Add program
    mutating func addProgram(_ program:Program) {
        programs.append(program)
    }
    
    //MARK: Remove program
    mutating func removeProgram(_ index:Int) {
        programs.remove(at: index)
    }
    //MARK: Find exercises by find textfield
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



//MARK: Charts object Set info
struct SetInfo:Identifiable {
    var id = UUID()
    
    var month:String
    //[(Weight,Reps)]
    var arrayOfSets:[oneSet]
    
    
    struct oneSet:Identifiable {
        var id = UUID()
        var date: String
        var approach: [repsAndWeight]
        
        struct repsAndWeight:Identifiable {
            var id = UUID()
            var rep: Double
            var weight: Double
        }
    }
}


//MARK: Exercise
class Exercise:Equatable,Identifiable,Hashable {
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
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

//MARK: Set struct
struct Sets: Identifiable,Equatable {
    var id = UUID()
    var number: Int
    var date:Date
    var weight:Double
    var reps:Double
    var doubleWeight:Bool
    var selfWeight:Bool
    
    init(id: UUID = UUID(), number: Int, date:Date, weight: Double, reps: Double, doubleWeight: Bool, selfWeight: Bool) {
        self.id = id
        self.number = number
        self.date = date
        self.weight = weight
        self.reps = reps
        self.doubleWeight = doubleWeight
        self.selfWeight = selfWeight
    }
}

//MARK: Calendar collpasing values
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
//MARK: Collapsing CalendarView
enum Collapse:CGFloat {
    case collapsed = -295
    case opened = 0
}

//MARK: Extensions

//MARK: Colors
extension GymModel {
    static var colors = ["green","red","cyan","purple","yellow","gray","blue","orange","pink","indigo","teal"]
    }
    

//MARK: All types of exercises
extension GymModel.TypeOfExercise{
    static var allExercises:[GymModel.TypeOfExercise] = [.arms,.stretching,.legs,.back,.chest,.abs,.shoulders,.cardio]
}


//MARK: Basic exercises,alerts and Programs
extension GymModel {
    //Basic exercises
    static var arrayOfAllCreatedExercises = [
        //Cardio
        Exercise(type: .cardio, name: "Running", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .cardio, name: "Cycling", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .cardio, name: "Elips", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        //Arms (Biceps)
        Exercise(type: .arms, name: "Dumbbell Concentration Curl", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .arms, name: "Dumbbell Hammers Curl", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .arms, name: "Biceps Curl", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        //Arms (Triceps)
        Exercise(type: .arms, name: "Dumbbell Standing Triceps Extension", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .arms, name: "Close grip push ups", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .arms, name: "Tricep Pushdown With Bar", doubleWeight: false, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        //Chest
        Exercise(type: .chest, name: "Dumbbell bench press", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .chest, name: "Push ups", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .chest, name: "Decline bench press", doubleWeight: false, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        //Shoulders
        Exercise(type: .shoulders, name: "Dumbbell front raise", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .shoulders, name: "Dumbbell shoulder press", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .shoulders, name: "Dumbbell Lateral Raise", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        //Legs
        Exercise(type: .legs, name: "Squat", doubleWeight: false, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .legs, name: "Leg press", doubleWeight: false, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .legs, name: "Barbell lunge", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        //Back
        Exercise(type: .back, name: "Pull ups with additional weight", doubleWeight: false, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .back, name: "Dumbbell row", doubleWeight: true, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .back, name: "Pull ups", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        //Abs
        Exercise(type: .abs, name: "Hanging Leg Raise", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .abs, name: "Crunch with weight", doubleWeight: false, selfWeight: false,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .abs, name: "Lying leg press", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        //Stretching
        Exercise(type: .stretching, name: "Child’s Pose", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .stretching, name: "Knee-to-chest stretch", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false),
        Exercise(type: .stretching, name: "Behind-head tricep stretch", doubleWeight: false, selfWeight: true,isSelected: false, sets: [], isSelectedToAddSet: false)
    ]
    
    static var basicPrograms =  [
        GymModel.Program(numberOfProgram: 1,programTitle: "Arms", programDescription: "Arms training basic program", colorDesign: "blue", exercises: GymModel.arrayOfAllCreatedExercises.filter({$0.type == .arms})),
        GymModel.Program(numberOfProgram: 2,programTitle: "Legs", programDescription: "Legs training basic program", colorDesign: "green", exercises: GymModel.arrayOfAllCreatedExercises.filter({$0.type == .legs})),
        GymModel.Program(numberOfProgram: 3,programTitle: "Shoulders", programDescription: "Shoulders training basic program", colorDesign: "red", exercises: GymModel.arrayOfAllCreatedExercises.filter({$0.type == .shoulders})),
        GymModel.Program(numberOfProgram: 4,programTitle: "Chest", programDescription: "Chest training basic program", colorDesign: "cyan", exercises: GymModel.arrayOfAllCreatedExercises.filter({$0.type == .chest})),
        GymModel.Program(numberOfProgram: 5,programTitle: "Back", programDescription: "Back training basic program", colorDesign: "orange", exercises: GymModel.arrayOfAllCreatedExercises.filter({$0.type == .back})),
        GymModel.Program(numberOfProgram: 6,programTitle: "ABS", programDescription: "ABS training basic program", colorDesign: "gray", exercises: GymModel.arrayOfAllCreatedExercises.filter({$0.type == .abs})),
        GymModel.Program(numberOfProgram: 7,programTitle: "Cardio", programDescription: "Cardio training basic program", colorDesign: "indigo", exercises: GymModel.arrayOfAllCreatedExercises.filter({$0.type == .cardio})),
        GymModel.Program(numberOfProgram: 8,programTitle: "Stretching", programDescription: "Stretching training basic program", colorDesign: "pink", exercises: GymModel.arrayOfAllCreatedExercises.filter({$0.type == .stretching}))
    ]
    
    static var doubleWeightAlertText = "For exercises with two projectiles (for example, with two dumbbells) specify the weight of only one projectile, then the tonnage statistics will be doubled and calculated correctly"
    
    static var bodyWeightAlertText = "For exercises with own weight (e.g. push-ups) instead of tonnage statistics will be displayed repetition statistics. If necessary, you can record the weight of the additional weight or leave the field empty"
}


//extension GymModel.Program {
//    static var exercises = GymModel.arrayOfAllCreatedExercises
//    
//}

//MARK: Remove zeros from End
extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}




