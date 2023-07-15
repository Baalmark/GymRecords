//
//  GymRecordsApp.swift
//  GymRecords
//
//  Created by Pavel Goldman on 14.01.2023.
//

import SwiftUI

@main

struct GymRecordsApp: App {
    var body: some Scene {
        let viewModel = GymViewModel()
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
            
            ContentView().environmentObject(viewModel)
        }
    }
}
