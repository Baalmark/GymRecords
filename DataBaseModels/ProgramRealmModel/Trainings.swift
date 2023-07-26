//
//  Trainings.swift
//  GymRecords
//
//  Created by Pavel Goldman on 26.07.2023.
//

import Foundation
import RealmSwift

class Trainings:Object,Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var trainingInfoObjects:List<TrainingInfoObject> = List<TrainingInfoObject>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
