//
//  TestObject.swift
//  GymRecords
//
//  Created by Pavel Goldman on 26.07.2023.
//

import Foundation



import Foundation
import RealmSwift

class TestObject:Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var programTitle: String
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
