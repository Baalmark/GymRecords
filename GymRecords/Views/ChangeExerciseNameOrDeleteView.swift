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
                    .foregroundColor(Color("LightGrayColor"))
                    .tint(.white)
                    .fixedSize()
                    .font(.title2)
            }
            .offset(x:viewModel.screenWidth / 2,y:0)
            .padding(.trailing,70)
            
            //TextField of exercise title
            VStack {
                Divider().overlay(viewModel.isDarkMode ?.white : Color("GrayColor"))
                
                TextField("Title for exercise:", text: $exercise.name)
                
                    .padding(10)
                    .foregroundColor(viewModel.isDarkMode ?.white : Color("GrayColor"))
                    .background(Rectangle()
                        .cornerRadius(viewModel.viewCornerRadiusSimple)
                        .foregroundColor(viewModel.isDarkMode ? Color("backgroundColor") : Color("LightGrayColor")))
                    .padding([.top,.bottom], 2)
                
                
                Divider().overlay(viewModel.isDarkMode ?.white : Color("GrayColor"))
                    .padding(.bottom,25)
                HStack {
                    Text("Double Weight")
                    
                    Button() {
                        isShowAlertDoubleWeight.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                    }.offset(x:viewModel.constW(w:20),y:0)
                        .alert(isPresented: $isShowAlertDoubleWeight) {
                            Alert(title:Text("Double Weight"),message:Text(GymModel.doubleWeightAlertText),dismissButton: .cancel(Text("OK")))
                        }
                    Toggle("", isOn: $exercise.doubleWeight)
                }
                .foregroundColor(viewModel.isDarkMode ? Color("MidGrayColor"): .black)
                Divider().overlay(Color("GrayColor"))
                HStack {
                    Text("Body Weight")
                    
                    Button() {
                        isShowAlertBodyWeight.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                    }.offset(x:viewModel.constW(w:20),y:0)
                        .alert(isPresented: $isShowAlertBodyWeight) {
                            Alert(title:Text("Body Weight"),message:Text(GymModel.bodyWeightAlertText),dismissButton: .cancel(Text("OK")))
                        }
                    Toggle("", isOn: $exercise.selfWeight)
                }
                .foregroundColor(viewModel.isDarkMode ? Color("MidGrayColor"): .black)
                Divider().overlay(Color("GrayColor"))
                
                Button{
                    viewModel.removeSomeExercise(exercise: exercise)
                    dismiss()
                } label: {
                    Text("Remove exercise")
                        .foregroundColor(Color("BrightRedColor"))
                }
                .offset(x:viewModel.constW(w:-90),y:viewModel.constH(h:10))
                .padding()
                Spacer()
                Button("Save") {
                    viewModel.toggleBodyAndDoubleWeight(exercise: exercise, bodyWeight: exercise.selfWeight, doubleWeight: exercise.doubleWeight)
                    dismiss()
                }
                .buttonStyle(GrowingButton(isDarkMode: viewModel.isDarkMode ,width: viewModel.constW(w:335),height: viewModel.constH(h:45)))
                
            }
            .font(.title2)
            .fontWeight(.bold)
            .padding(20)
        }.background(Color("backgroundColor"))
            .onTapGesture {
                self.hideKeyboard()
            }
        
    }
}

struct ChangeExerciseNameOrDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()
        ChangeExerciseNameOrDeleteView(exercise: .constant(Exercise(type: .cardio, name: "Running", doubleWeight: false, selfWeight: true, isSelected: false, sets: [], isSelectedToAddSet: false))).environmentObject(GymViewModel())
    }
}
