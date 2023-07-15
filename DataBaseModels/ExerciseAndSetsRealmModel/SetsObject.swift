//
//  SetsObject.swift
//  GymRecords
//
//  Created by Pavel Goldman on 15.07.2023.
//

import Foundation
import RealmSwift


class SetsObject: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var number: Int
    @Persisted var date:Date
    @Persisted var weight:Double
    @Persisted var reps:Double
    @Persisted var doubleWeight:Bool
    @Persisted var selfWeight:Bool
    
    
    
}
