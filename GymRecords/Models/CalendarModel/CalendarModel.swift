//
//  CalendarModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 07.03.2023.
//

import Foundation


class CalendarModel
{
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    func monthYearString(_ date: Date) -> String
    {
        dateFormatter.dateFormat = "LLLL yyyy"
        return dateFormatter.string(from: date).capitalized
    }
    
    func plusMonth(_ date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(_ date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func selectDay(_ date: Date, day:Int) -> Date
    {
        var dateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        dateComponents.hour = 14
        dateComponents.day = day
        dateComponents.month = dateComponents.month
        dateComponents.year = dateComponents.year

        let newDate = Calendar.current.date(from: dateComponents)
        return newDate!
    }
    
    func daysInMonth(_ date: Date) -> Int
    {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(_ date: Date) -> Int
    {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(_ date: Date) -> Date
    {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(_ date: Date) -> Int
    {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func scrollingCalendarUP(array:[Date]) -> Array<Date> {
        
        //There are 3 elements here
        var newArray:[Date] = []
        
        for element in array {
            let element = plusMonth(element)
            newArray.append(element)
        }
        
        return newArray
        
    }
    
}
