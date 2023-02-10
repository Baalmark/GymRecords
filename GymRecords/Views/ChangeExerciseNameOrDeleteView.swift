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
    
    
    @State var isShowAlertDoubleWeight = false
    @State var isShowAlertBodyWeight = false
    
    var body: some View {
        VStack {
            //Close button
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.white)
                    .fixedSize()
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
                        isShowAlertDoubleWeight.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                    }.offset(x:20,y:0)
                        .alert(isPresented: $isShowAlertDoubleWeight) {
                            Alert(title:Text("Double Weight"),message:Text(GymModel.doubleWeightAlertText),dismissButton: .cancel(Text("OK")))
                        }
                    Toggle("", isOn: $exercise.doubleWeight)
                }
                .foregroundColor(Color("MidGrayColor"))
                Divider().overlay(Color("GrayColor"))
                HStack {
                    Text("Body Weight")
                        
                    Button() {
                        isShowAlertBodyWeight.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                    }.offset(x:20,y:0)
                        .alert(isPresented: $isShowAlertBodyWeight) {
                            Alert(title:Text("Body Weight"),message:Text(GymModel.bodyWeightAlertText),dismissButton: .cancel(Text("OK")))
                        }
                    Toggle("", isOn: $exercise.selfWeight)
                }
                .foregroundColor(Color("MidGrayColor"))
                Divider().overlay(Color("GrayColor"))
                
                Button{
                    viewModel.removeSomeExercise(exercise: exercise)
                    dismiss()
                } label: {
                    Text("Remove exercise")
                        .foregroundColor(Color("RedColorScarlet"))
                }
                .offset(x:-90,y:10)
                .padding()
                Spacer()
                Button("Save") {
                    viewModel.toggleBodyAndDoubleWeight(exercise: exercise, bodyWeight: exercise.selfWeight, doubleWeight: exercise.doubleWeight)
                    dismiss()
                }
                .buttonStyle(GrowingButton(isDarkMode: true,width: 335,height: 45))
                .foregroundColor(Color("DarkGrayColor"))
                
            }
            .font(.title2)
            .fontWeight(.bold)
            .padding(20)
        }.background(Color("backgroundColor"))
    }
}

struct ChangeExerciseNameOrDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeExerciseNameOrDeleteView(exercise: .constant(Exercise(type: .cardio, name: "Running", doubleWeight: false, selfWeight: true, isSelected: false))).environmentObject(GymViewModel())
    }
}
