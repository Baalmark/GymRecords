//
//  CreateNewExercise.swift
//  GymRecords
//
//  Created by Pavel Goldman on 10.02.2023.
//

import SwiftUI

struct CreateNewExercise: View {
    
    
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @State var typeOfExercise:GymModel.TypeOfExercise
    @Binding var showView:Bool
    @State var name = ""
    @State var bodyWeight:Bool = false
    @State var doubleWeight:Bool = false
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
                Divider().overlay(viewModel.isDarkMode ? .white : .gray)
                
                TextField("", text: $name)
                    
                    .placeholder(when: name.isEmpty) {
                        Text("Title for exercise")
                            .foregroundColor(viewModel.isDarkMode ? .gray : Color("GrayColor"))
                    }
                    .padding(10)
                    .foregroundColor(viewModel.isDarkMode ? .white : .black)
                    .background(Rectangle()
                        .cornerRadius(viewModel.viewCornerRadiusSimple)
                        .foregroundColor(viewModel.isDarkMode ? Color("backgroundColor") : Color("LightGrayColor")))
                    .padding([.top,.bottom], 2)
                
                Divider().overlay(viewModel.isDarkMode ? .white : .gray)
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
                    Toggle("", isOn: $doubleWeight)
                }
                .foregroundColor(viewModel.isDarkMode ? Color("MidGrayColor") : Color(.black))
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
                    Toggle("", isOn: $bodyWeight)
                }
                .foregroundColor(viewModel.isDarkMode ? Color("MidGrayColor") : Color(.black))
                Divider().overlay(Color("GrayColor"))
                
                Spacer()
                HStack {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica", size: 14))
                            .fontWeight(.bold)
                            .padding(10)
                            .background(Circle())
                            .foregroundColor(Color("MidGrayColor").opacity(viewModel.isDarkMode ? 0.1 : 0.5))
                        
                    }
                    Spacer()
                    if name != "" {
                        Button("Create exercise") {
                            if name != "" {
                                let newElement = Exercise(type: typeOfExercise, name: name, doubleWeight: doubleWeight, selfWeight: bodyWeight, isSelected: false)
                                viewModel.createNewExercise(exercise: newElement)
                            }
                            dismiss()
                        }
                        .buttonStyle(GrowingButton(isDarkMode: viewModel.isDarkMode,width: 335 - 50,height: 45))
                        .foregroundColor(Color("DarkGrayColor"))
                    }
                }
                .padding([.leading,.trailing],-5)
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

struct CreateNewExercise_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewExercise(typeOfExercise: .arms, showView: .constant(true)).environmentObject(GymViewModel())
    }
}
