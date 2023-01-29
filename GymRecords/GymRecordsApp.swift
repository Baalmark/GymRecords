//
//  GymRecordsApp.swift
//  GymRecords
//
//  Created by Pavel Goldman on 14.01.2023.
//

import SwiftUI

@main

struct GymRecordsApp: App {
    @StateObject var myEvents = EventStore(preview: true)
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(myEvents)
        }
    }
}
