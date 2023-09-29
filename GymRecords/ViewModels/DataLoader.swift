//
//  LoadDataFromRealmDBModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 11.09.2023.
//

import Foundation
import RealmSwift
class DataLoader {
    
    lazy var realm = try! Realm()
    
    @ObservedResults(ProgramObject.self) var programObjects
    @ObservedResults(ExerciseObject.self) var exerciseObjects
    @ObservedResults(TrainingInfoObject.self) var trainingInfoObjects
    @ObservedResults(GymModelObject.self) var gymModelObjects
    @ObservedResults(SetsObject.self) var setsObject
    
    init() {
        
        
    }
    
    //MARK: Load programs from Realm Data Base function
    func loadPrograms() -> [GymModel.Program]{
        
        var result:[GymModel.Program] = []
        if !programObjects.isEmpty {
            for program in programObjects {
                let allExercises = getAllExercises(program: program)
                
                let newProgram = GymModel.Program(numberOfProgram: program.numberOfProgram,programTitle: program.programTitle, programDescription: program.programDescription, colorDesign: program.colorDesign, exercises: allExercises)
                result.append(newProgram)
            }
        } else {
            result =  [GymModel.Program(numberOfProgram: 1,programTitle: "Test", programDescription: "Testing", colorDesign: "green", exercises: GymModel.arrayOfAllCreatedExercises)]
            
            saveProgramIntoRealmDB(newProgram: result.first!)
            
            
        }
        return result
    }
    //MARK: Create GymModelObject
    func createGymModelObject() {
        let newGymModelObject = GymModelObject()
        let exercises = realm.objects(ExerciseObject.self)
        let trainings = realm.objects(TrainingInfoObject.self)
        let programs = realm.objects(ProgramObject.self)
        
        
        let programsList = programs.list
        let exercisesList = exercises.list
        let trainingsList = trainings.list
        
        newGymModelObject.arrayOfExercises = exercisesList
        newGymModelObject.programs = programsList
        newGymModelObject.trainingDictionary = trainingsList
        
        $gymModelObjects.append(newGymModelObject)
    }
    
    //MARK: Load Exercises From Realm DB
    func loadExercises() -> [Exercise]{
        var duplicateFlag = false
        var result:[Exercise] = []
        if exerciseObjects.count >= GymModel.arrayOfAllCreatedExercises.count {
            for ex in exerciseObjects {
                var allSets:[Sets] = []
                for nSet in ex.sets {
                    let newSet = Sets(number: nSet.number, date: nSet.date ,weight: nSet.weight, reps: nSet.reps, doubleWeight: nSet.doubleWeight, selfWeight: nSet.selfWeight)
                    allSets.append(newSet)
                    
                }
                if let type = GymModel.TypeOfExercise(rawValue: ex.type) {
                    let exercise = Exercise(type: type, name: ex.name, doubleWeight: ex.doubleWeight, selfWeight: ex.selfWeight, isSelected: ex.isSelected, sets: allSets, isSelectedToAddSet: ex.isSelectedToAddSet)
                    
                    for ex in result {
                        if ex.name == exercise.name {
                            duplicateFlag = true
                        }
                    }
                    if !duplicateFlag {
                        result.append(exercise)
                    }
                    duplicateFlag = false
                }
            }
            
            
        } else {
            for element in GymModel.arrayOfAllCreatedExercises {
                saveExerciseByRealmDB(exercise: element)
            }
            result = GymModel.arrayOfAllCreatedExercises
        }
        return result
    }
    
    //MARK: Load sets for exercises
    func loadSetsToExercise(name:String) -> [Sets] {
        
        var result:[Sets] = []
        
        let realmExercise = realm.objects(ExerciseObject.self).where { $0.name == name}.first!
        
        for nSet in realmExercise.sets {
            let newSet = Sets(number: nSet.number, date: nSet.date, weight: nSet.weight, reps: nSet.reps, doubleWeight: nSet.doubleWeight, selfWeight: nSet.selfWeight)
            result.append(newSet)
        }
        return result
    }
    
    //MARK: Save exercise in the Realm Data Base
    func saveExerciseByRealmDB(exercise:Exercise) {
        
        let newExercise = ExerciseObject()
        newExercise.name = exercise.name
        newExercise.doubleWeight = exercise.doubleWeight
        newExercise.selfWeight = exercise.selfWeight
        newExercise.type = exercise.type.rawValue
        
        //Let's create Sets in the Realm Format SetsObjects
        
        for nSet in exercise.sets {
            let newSet = SetsObject()
            newSet.date = nSet.date
            newSet.doubleWeight = nSet.doubleWeight
            newSet.number = nSet.number
            newSet.reps = nSet.reps
            newSet.weight = nSet.weight
            newSet.selfWeight = nSet.selfWeight
            newExercise.sets.append(newSet)
            
        }
        $exerciseObjects.append(newExercise)
        composeGymModelObject()
    }
    
    //MARK: Save original(first) exercise in the Realm Data Base
    func saveCreatedExerciseByRealm() {
        for exercise in GymModel.arrayOfAllCreatedExercises {
            let newExercise = ExerciseObject()
            newExercise.name = exercise.name
            newExercise.doubleWeight = exercise.doubleWeight
            newExercise.selfWeight = exercise.selfWeight
            newExercise.type = exercise.type.rawValue
            
            
            //Let's create Sets in the Realm Format SetsObjects
            
            for nSet in exercise.sets {
                let newSet = SetsObject()
                newSet.date = nSet.date
                newSet.doubleWeight = nSet.doubleWeight
                newSet.number = nSet.number
                newSet.reps = nSet.reps
                newSet.weight = nSet.weight
                newSet.selfWeight = nSet.selfWeight
                newExercise.sets.append(newSet)
                
            }
            $exerciseObjects.append(newExercise)
            
        }
        composeGymModelObject()
    }
    
    //MARK: Load trainings from Realm Data Base function
    func loadTrainingDictionary() -> [String:GymModel.Program] {
        var result:[String:GymModel.Program] = [:]
        
        if trainingInfoObjects.isEmpty {
            return result
        } else {
            for train in trainingInfoObjects {
                if let program = train.program {
                    let allExercises = getAllExercises(program: program)
                    let newTrainProgram = GymModel.Program(numberOfProgram: program.numberOfProgram,programTitle: program.programTitle, programDescription: program.programDescription, colorDesign: program.colorDesign, exercises: allExercises)
                    let dateForProgram = train.date
                    
                    result[dateForProgram] = newTrainProgram
                }
            }
        }
        return result
    }
    //MARK: Get all exercises function
    func getAllExercises(program:ProgramObject) -> [Exercise] {
        
        var allExercises:[Exercise] = []
        for ex in program.exercises {
            var allSets:[Sets] = []
            for nSet in ex.sets {
                let newSet = Sets(number: nSet.number,date: nSet.date ,weight: nSet.weight, reps: nSet.reps, doubleWeight: nSet.doubleWeight, selfWeight: nSet.selfWeight)
                allSets.append(newSet)
            }
            if let type = GymModel.TypeOfExercise(rawValue: ex.type) {
                let exercise = Exercise(type: type, name: ex.name, doubleWeight: ex.doubleWeight, selfWeight: ex.selfWeight, isSelected: ex.isSelected, sets: allSets, isSelectedToAddSet: ex.isSelectedToAddSet)
                allExercises.append(exercise)
            }
        }
        return allExercises
    }
    
    //MARK: Change program in realm DB
    func changeProgramRealm(program:GymModel.Program) {
        if let programFromRealmDB = realm.objects(ProgramObject.self).where({ $0.numberOfProgram == program.numberOfProgram}).first {
            try! realm.write {
                programFromRealmDB.programTitle = program.programTitle
                programFromRealmDB.colorDesign = program.programDescription
                programFromRealmDB.programDescription = program.colorDesign
                programFromRealmDB.exercises.removeAll()
                for element in program.exercises {
                    let exerciseRealm = reformattingExerciseToRealmFormat(element:element)
                    programFromRealmDB.exercises.append(exerciseRealm)
                }
            }
            
        }
    }
    //MARK: Saving all data by Realm

    //MARK: Save Program into realm Data Base
     func createRealmFormatOfProgramObject(_ programObject: ProgramObject, _ newProgram: GymModel.Program) {
        
                programObject.colorDesign = newProgram.colorDesign
                programObject.programDescription = newProgram.programDescription
                programObject.programTitle = newProgram.programTitle
        
        for element in newProgram.exercises {
            
            let exerciseRealm = reformattingExerciseToRealmFormat(element:element)
            programObject.exercises.append(exerciseRealm)
        }
    }
    //MARK: Save Program into Realm DB
        func saveProgramIntoRealmDB(newProgram:GymModel.Program) {
                let programObject = ProgramObject()
                createRealmFormatOfProgramObject(programObject, newProgram)
                $programObjects.append(programObject)
                composeGymModelObject()
        }
    //MARK: Create sets for Realm Exercise
    func setCreatorForRealm(_ element: Exercise, _ exerciseObject: ExerciseObject) {
        
        for nSet in element.sets {
            let setObject = SetsObject()
            setObject.number = nSet.number
            setObject.date = nSet.date
            setObject.doubleWeight = nSet.doubleWeight
            setObject.selfWeight = nSet.selfWeight
            setObject.reps = nSet.reps
            setObject.weight = nSet.weight
            exerciseObject.sets.append(setObject)
        }
    }
    //MARK: Return count of existing training
    
    func returnCountOfTrainings() -> Int {
        return realm.objects(TrainingInfoObject.self).count
    }
    //MARK: Return count of existing program
    
    func returnCountOfPrograms() -> Int {
        return realm.objects(ProgramObject.self).count
    }
    //MARK: Return count of existing exercises
    
    func returnCountOfExercises() -> Int {
        return realm.objects(ExerciseObject.self).count
    }
    //MARK: Save trainings into Realm Data Base
    func saveTrainingIntoRealmDB(date:String,exercises:[Exercise]) {
        let newTraining = TrainingInfoObject()
        newTraining.date = date
        let newProgram = ProgramObject()
        for element in exercises {
            
            let exerciseRealm = reformattingExerciseToRealmFormat(element:element)
            
            setCreatorForRealm(element, exerciseRealm)
            newProgram.numberOfProgram = realm.objects(ProgramObject.self).count + 1
            newProgram.exercises.append(exerciseRealm)
            newProgram.programTitle = date
            newProgram.programDescription = ""
            newProgram.colorDesign = "green"
            
        }
        newTraining.program = newProgram
        $trainingInfoObjects.append(newTraining)
        composeGymModelObject()
    }

    //MARK: Reformatting to Realm Format Exercise
    func reformattingExerciseToRealmFormat(element: Exercise) -> ExerciseObject{
        
        
        if let exerciseRealm = realm.objects(ExerciseObject.self).where({ $0.name == element.name }).first {
            setCreatorForRealm(element, exerciseRealm)
            return exerciseRealm
        }
        let exerciseRealm = ExerciseObject()
        exerciseRealm.name = element.name
        exerciseRealm.type = element.type.rawValue
        exerciseRealm.doubleWeight = element.doubleWeight
        exerciseRealm.selfWeight = element.selfWeight
        exerciseRealm.isSelectedToAddSet = element.isSelectedToAddSet
        exerciseRealm.isSelected = element.isSelected
        setCreatorForRealm(element, exerciseRealm)
        return exerciseRealm
    }
    //MARK: Save trainings into Realm DataBase
    func saveTrainingIntoRealmDB(date:String,program:GymModel.Program) {
        let newTraining = TrainingInfoObject()
        newTraining.date = date
//        let newProgram = ProgramObject()
//        for element in program.exercises {
//
//            let exerciseObject = reformattingExerciseToRealmFormat(element: element)
//
//
//            newProgram.numberOfProgram = program.numberOfProgram
//            newProgram.exercises.append(exerciseObject)
//            newProgram.programTitle = program.programTitle
//            newProgram.programDescription = program.programDescription
//            newProgram.colorDesign = program.colorDesign
//
//        }
        if let programRealm = realm.objects(ProgramObject.self).where({ $0.programTitle == program.programTitle}).first {
            newTraining.program = programRealm
            
        } else {
            let newProgramObject = ProgramObject()
            createRealmFormatOfProgramObject(newProgramObject,program)
            newTraining.program = newProgramObject
        }
        $trainingInfoObjects.append(newTraining)
        composeGymModelObject()
    }
    //MARK: Remove trainings into Realm DataBase
    func removeTrainingFromRealmDB(date:String,program:GymModel.Program) {
        
        let programToDelete = realm.objects(TrainingInfoObject.self).where {
            $0.date == date
            
        }.first!
        try! realm.write {
            $trainingInfoObjects.remove(programToDelete)
        }
    }

    //MARK: Saving created exercise

    func saveExerciseByRealm(exercise:Exercise) {
        let newExercise = reformattingExerciseToRealmFormat(element:exercise)
        
        //Let's create Sets in the Realm Format SetsObjects
        setCreatorForRealm(exercise, newExercise)
        $exerciseObjects.append(newExercise)
        composeGymModelObject()
    }
    
    //MARK: Composing GymModelObjects
    func composeGymModelObject() {
        
        let newGymModelObject = GymModelObject()
        let exercises = realm.objects(ExerciseObject.self)
        let trainings = realm.objects(TrainingInfoObject.self)
        let programs = realm.objects(ProgramObject.self)
        let models = realm.objects(GymModelObject.self)
        
        let programsList = programs.list
        let exercisesList = exercises.list
        let trainingsList = trainings.list
        
        newGymModelObject.arrayOfExercises = exercisesList
        newGymModelObject.programs = programsList
        newGymModelObject.trainingDictionary = trainingsList
        
        let gymModelObject = models.last
        try! realm.write {
            gymModelObject?.arrayOfExercises = exercisesList
            gymModelObject?.programs = programsList
            gymModelObject?.trainingDictionary = trainingsList
        }
    }
    
}
