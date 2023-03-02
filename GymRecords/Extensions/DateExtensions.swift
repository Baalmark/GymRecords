//
//  DateExtensions.swift
//  GymRecords
//
//  Created by Pavel Goldman on 02.03.2023.
//

import Foundation


extension Date{
    
    func diff(numDays: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: numDays, to: self)!
    }
    
    var startOfDay:Date {
        Calendar.current.startOfDay(for: self)
    }
    
    
}
