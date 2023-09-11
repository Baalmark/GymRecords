//
//  TrainingInfoObject.swift
//  GymRecords
//
//  Created by Pavel Goldman on 15.07.2023.
//

import Foundation
import RealmSwift

class TrainingInfoObject:Object,Identifiable {
    
    
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var program:ProgramObject?
    @Persisted var date:String
    override class func primaryKey() -> String? {
        return "date"
    }
}
