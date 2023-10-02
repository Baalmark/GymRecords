//
//  GymRecordsApp.swift
//  GymRecords
//
//  Created by Pavel Goldman on 14.01.2023.
//

import SwiftUI

@main

struct GymRecordsApp: App {
    @Environment(\.realm) private var realm
    var body: some Scene {
        
        let _ = Migrator()
        
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            
            ContentView()
        }
    }
}

