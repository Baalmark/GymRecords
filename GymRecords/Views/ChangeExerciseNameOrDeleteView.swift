//
//  ChangeExerciseNameOrDeleteView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 09.02.2023.
//

import SwiftUI

struct ChangeExerciseNameOrDeleteView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel:GymViewModel
    @Binding var exercise:Exercise
    
    var body: some View {
        VStack {
            //Close button
            Button {
                dismiss()
            } label: {
                Image(systemName: "x.circle.fill")
                    .foregroundColor(viewModel.systemColorGray)
                    .font(.title2)
            }
            .offset(x:viewModel.screenWidth / 2,y:0)
            .padding(.trailing,70)
            
            //TextField of exercise title
            VStack {
                Divider().overlay(.white)
                
                TextField("Title for exercise:", text: $exercise.name)
                    .padding([.top,.bottom],5)
                    .foregroundColor(.white)
                    
                Divider().overlay(.white)
                    .padding(.bottom,25)
                HStack {
                    Text("Double Weight")
                        
                    Button() {
                        
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(viewModel.systemColorGray)
                    }.offset(x:10,y:0)
                    Toggle("", isOn: $exercise.doubleWeight)
                }
                .foregroundColor(viewModel.systemColorMidGray)
                Divider().overlay(viewModel.systemColorGray)
                HStack {
                    Text("Self Weight")
                        
                    Button() {
                        
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(viewModel.systemColorGray)
                    }.offset(x:10,y:0)
                    Toggle("", isOn: $exercise.selfWeight)
                }
                .foregroundColor(viewModel.systemColorMidGray)
                Divider().overlay(viewModel.systemColorGray)
                
                Button{
                    viewModel.removeSomeExercise(exercise: exercise)
                    dismiss()
                } label: {
                    Text("Remove exercise")
                        .foregroundColor(viewModel.systemRed)
                }
                .offset(x:-90,y:10)
                .padding()
                Spacer()
                Button("Save") {
                    dismiss()
                }
                .foregroundColor(viewModel.systemDarkGray)
                .background(RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .frame(width: viewModel.screenWidth - 40,height: 45)
                )
            }
            .font(.title2)
            .fontWeight(.bold)
            .padding(20)
        }.background(viewModel.systemDarkGray)
    }
}

struct ChangeExerciseNameOrDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeExerciseNameOrDeleteView(exercise: .constant(Exercise(type: .cardio, name: "Running", doubleWeight: false, selfWeight: true, isSelected: false))).environmentObject(GymViewModel())
    }
}
