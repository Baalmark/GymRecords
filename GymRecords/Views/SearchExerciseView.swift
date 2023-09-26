//
//  SearchExerciseView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 27.02.2023.
//

import SwiftUI

struct SearchExerciseView: View {
    @EnvironmentObject var viewModel:GymViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SearchExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()

        SearchExerciseView()
    }
}
