//
//  Event.swift
//  GymRecords
//
//  Created by Pavel Goldman on 20.01.2023.
//

import Foundation

struct Event:Identifiable {
    
    enum EventType: String,Identifiable,CaseIterable {
        case workout,gym,home,unspecified
        
        var id: String {
            self.rawValue
        }
        var icon:String {
            switch self {
            case .gym: return "🏋️"
            case .home:  return "🏠"
            case .workout:  return "🏃"
            case .unspecified:  return "🦾"
            }
            
        }
    }
    
    var id: String
    var eventType:EventType
    var note:String
    var date:Date
    
    
    init(id: String = UUID().uuidString, eventType: EventType, note: String, date: Date) {
        self.id = id
        self.eventType = eventType
        self.note = note
        self.date = date
    }
    
    
    
    
    
    
    static var sampleEvents: [Event] {
        
        return [
            Event(eventType: .gym, note: "GymTest", date: Date.now)
        ]
    }
    
}
