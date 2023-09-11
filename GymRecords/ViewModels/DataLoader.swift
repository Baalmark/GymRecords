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
    @ObservedResults(GymModelObject.self) var GymModelObjects

    
    init() {
        
        
    }
    //MARK: Load programs from Realm Data Base function
    func loadPrograms() -> [GymModel.Program]{
        
        var result:[GymModel.Program] = []
        if !programObjects.isEmpty {
            for program in programObjects {
                let allExercises = getAllExercises(program: program)
                
                let newProgram = GymModel.Program(programTitle: program.programTitle, programDescription: program.programDescription, colorDesign: program.colorDesign, exercises: allExercises)
                result.append(newProgram)
            }
        } else {
            let result =  [GymModel.Program(programTitle: "Test", programDescription: "Testing", colorDesign: "green", exercises: GymModel.arrayOfAllCreatedExercises)]
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
        
        $GymModelObjects.append(newGymModelObject)
    }
    
    //MARK: Load Exercises From Realm DB
    func loadExercises() -> [Exercise]{
        var duplicateFlag = false
        var result:[Exercise] = []
        if exerciseObjects.count >= GymModel.arrayOfAllCreatedExercises.count {
            for ex in exerciseObjects {
                var allSets:[Sets] = []
                for nSet in ex.sets {
                    let newSet = Sets(number: nSet.number, weight: nSet.weight, reps: nSet.reps, doubleWeight: nSet.doubleWeight, selfWeight: nSet.selfWeight)
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
                    let newTrainProgram = GymModel.Program(programTitle: program.programTitle, programDescription: program.programDescription, colorDesign: program.colorDesign, exercises: allExercises)
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
                let newSet = Sets(number: nSet.number, weight: nSet.weight, reps: nSet.reps, doubleWeight: nSet.doubleWeight, selfWeight: nSet.selfWeight)
                allSets.append(newSet)
            }
            if let type = GymModel.TypeOfExercise(rawValue: ex.type) {
                let exercise = Exercise(type: type, name: ex.name, doubleWeight: ex.doubleWeight, selfWeight: ex.selfWeight, isSelected: ex.isSelected, sets: allSets, isSelectedToAddSet: ex.isSelectedToAddSet)
                allExercises.append(exercise)
            }
        }
        return allExercises
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
