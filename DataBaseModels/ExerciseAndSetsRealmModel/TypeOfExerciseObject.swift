//
//  TypeOfExerciseObject.swift
//  GymRecords
//
//  Created by Pavel Goldman on 15.07.2023.
//

import Foundation
import RealmSwift

class TypeOfExerciseObject: Object{
    
    @Persisted var type: String = ""
    
}
