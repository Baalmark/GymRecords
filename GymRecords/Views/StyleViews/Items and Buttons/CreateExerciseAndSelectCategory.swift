//
//  CreateExerciseAndSelectCategory.swift
//  GymRecords
//
//  Created by Pavel Goldman on 13.02.2023.
//

import SwiftUI

struct CreateExerciseAndSelectCategory: View {
    @EnvironmentObject var viewModel:GymViewModel
    
    var body: some View {
        // Exercise Button
        Button {
            HapticManager.instance.impact(style: .medium)
        } label: {
            Text("Create Exercise")
                .font(.custom("Helvetica", size: viewModel.constW(w:18)))
                .fontWeight(.bold)
            Spacer()
            Text("+")
                .fontWeight(.regular)
        }
        .foregroundColor(Color("backgroundDarkColor"))
        .font(.custom("Helvetica", size: viewModel.constW(w:18)))
        .fontWeight(.bold)
        .padding(.trailing,10)
        .padding(20)
        .background(Rectangle()
            .foregroundColor(Color("LightGrayColor"))
            .frame(width: viewModel.screenWidth - 20, height: viewModel.constH(h:60))
            .cornerRadius(10))
        .padding(10)
    }
}

struct CreateExerciseAndSelectCategory_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()

        CreateExerciseAndSelectCategory().environmentObject(GymViewModel())
    }
}
