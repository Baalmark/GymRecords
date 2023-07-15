//
//  DataBase.swift
//  GymRecords
//
//  Created by Pavel Goldman on 15.07.2023.
//

import Foundation
import RealmSwift

class ExerciseObject: Object,Identifiable {
    
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var type: TypeOfExerciseObject = TypeOfExerciseObject()
    @Persisted var name: String
    @Persisted var doubleWeight:Bool
    @Persisted var selfWeight:Bool
    @Persisted var isSelected:Bool
    @Persisted var sets: List<SetsObject> = List<SetsObject>()
    @Persisted var isSelectedToAddSet:Bool
}


