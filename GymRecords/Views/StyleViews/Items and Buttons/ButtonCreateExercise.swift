//
//  ButtonCreateExercise.swift
//  GymRecords
//
//  Created by Pavel Goldman on 13.02.2023.
//

import SwiftUI

struct ButtonCreateExercise: View {
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var showCreateExercise:Bool
    var body: some View {
        HStack{
            // Exercise Button
            Button {
                HapticManager.instance.impact(style: .medium)
                showCreateExercise.toggle()
            } label: {
                Text("Create exercise")
                    .font(.custom("Helvetica", size: viewModel.constW(w:18)))
                    .fontWeight(.bold)
                Spacer()
                Text("+")
                    .fontWeight(.regular)
            }
            .foregroundColor(.black)
            .font(.custom("Helvetica", size: viewModel.constW(w:20)))
            .fontWeight(.bold)
            .padding(.trailing,10)
            .background(RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("LightGrayColor"))
                .frame(width: viewModel.screenWidth - 20, height: viewModel.constH(h:60)))
            
        }
        .padding(20)
        .background(Rectangle()
            .foregroundColor(Color("LightGrayColor"))
            .frame(width: viewModel.screenWidth - 20, height: viewModel.constH(h:60))
            .cornerRadius(10))
        .padding(10)
    }
}

struct ButtonCreateExercise_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()
        ButtonCreateExercise( showCreateExercise: .constant(false)).environmentObject(GymViewModel())
    }
}
