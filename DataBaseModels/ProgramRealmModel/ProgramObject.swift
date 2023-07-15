//
//  ProgramObject.swift
//  GymRecords
//
//  Created by Pavel Goldman on 15.07.2023.
//

import Foundation
import RealmSwift

class ProgramObject:Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var programTitle: String
    @Persisted var programdescription: String
    @Persisted var colorDesign: String
    @Persisted var exercises:List<ExerciseObject> = List<ExerciseObject>()
}
