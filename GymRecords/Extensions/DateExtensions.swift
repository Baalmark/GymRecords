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
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }

}
