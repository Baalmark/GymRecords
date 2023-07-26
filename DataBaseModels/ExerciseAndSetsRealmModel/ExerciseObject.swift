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
    
    @Persisted var type: String
    @Persisted var name: String
    @Persisted var doubleWeight:Bool
    @Persisted var selfWeight:Bool
    @Persisted var isSelected:Bool
    @Persisted var sets: List<SetsObject> = List<SetsObject>()
    @Persisted var isSelectedToAddSet:Bool
    
    override class func primaryKey() -> String? {
        return "id"
    }
}


