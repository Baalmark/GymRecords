//
//  GymModelObject.swift
//  GymRecords
//
//  Created by Pavel Goldman on 15.07.2023.
//

import Foundation
import RealmSwift

class GymModelObject:Object,Identifiable {
    
    @Persisted(primaryKey: true) var id:ObjectId
    
    @Persisted var programs: List<ProgramObject> = List<ProgramObject>()
    @Persisted var typesExercises:List<TypeOfExerciseObject> = List<TypeOfExerciseObject>()
    @Persisted var arrayOfExercises:List<ExerciseObject> = List<ExerciseObject>()
    @Persisted var trainingDictionary:List<TrainingInfoObject> = List<TrainingInfoObject>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
}
