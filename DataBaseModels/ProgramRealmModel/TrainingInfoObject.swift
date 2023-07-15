//
//  TrainingInfoObject.swift
//  GymRecords
//
//  Created by Pavel Goldman on 15.07.2023.
//

import Foundation
import RealmSwift

class TrainingInfoObject:Object {
    @Persisted var arrayOfExercises: List<ExerciseObject> = List<ExerciseObject>()
    @Persisted var Date:Date
}
