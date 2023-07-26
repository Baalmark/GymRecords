//
//  Migrator.swift
//  GymRecords
//
//  Created by Pavel Goldman on 26.07.2023.
//

import Foundation
import RealmSwift

class Migrator {
    
    init() {
        updateSchema()
    }
    func updateSchema() {
        let config = Realm.Configuration(schemaVersion: 1) { migration ,oldSchemaVersions in
            if oldSchemaVersions < 1 {
                //add new fields
                migration.enumerateObjects(ofType: ExerciseObject.className()) { _, newObject in
                    newObject!["sets"] = List<SetsObject>()
                }
            }
            
        }
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
    
    
}
