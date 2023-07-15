//
//  GymModelObject.swift
//  GymRecords
//
//  Created by Pavel Goldman on 15.07.2023.
//

import Foundation
import RealmSwift

class GymModelObject:Object {
    
    @Persisted var programs: List<ProgramObject> = List<ProgramObject>()
    
    @Persisted var typesExercises:List<TypeOfExerciseObject> = List<TypeOfExerciseObject>()
    @Persisted var arrayOfExercises:List<ExerciseObject> = List<ExerciseObject>()
    @Persisted var arrayOfPlannedTrainings:List<TrainingInfoObject> = List<TrainingInfoObject>()
    @Persisted var trainingDictionary:Map<String,ProgramObject> = Map<String,ProgramObject>()
    
    
    
}
