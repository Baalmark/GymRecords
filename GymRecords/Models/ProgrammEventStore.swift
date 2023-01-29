//
//  ProgrammEventStore.swift
//  GymRecords
//
//  Created by Pavel Goldman on 20.01.2023.
//

import Foundation

class EventStore:ObservableObject {
    @Published var events = [Event]()
    @Published var preview:Bool
    
    init(preview:Bool = false) {
        self.preview = preview
        fetchEvents()

    }
    
    func fetchEvents() {
        if preview {
            events = Event.sampleEvents
        } else {
            
        }
        
    }
}
