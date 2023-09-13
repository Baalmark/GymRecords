//
//  ProgramObject.swift
//  GymRecords
//
//  Created by Pavel Goldman on 15.07.2023.
//

import Foundation
import RealmSwift

class ProgramObject:Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var numberOfProgram:Int
    @Persisted var programTitle: String
    @Persisted var colorDesign: String
    @Persisted var exercises:List<ExerciseObject> = List<ExerciseObject>()
    @Persisted var programDescription: String
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
