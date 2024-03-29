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

    @State var name = ""
    @State var bodyWeight:Bool = false
    @State var doubleWeight:Bool = false
    @State var isShowAlertDoubleWeight = false
    @State var isShowAlertBodyWeight = false
    @State var isNoCategoryCreating:Bool
    var body: some View {
        VStack(alignment:.leading) {
            //Close button
            HStack {
                Text("\(typeOfExercise.rawValue.capitalized)")
                    .foregroundColor(isNoCategoryCreating ? .white : .black)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(20)
                Spacer()
                Button {
                    HapticManager.instance.impact(style: .medium)
                    viewModel.isShowedCreateExView.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(isNoCategoryCreating ? Color("GrayColor") : Color("MidGrayColor"))
                        .tint(isNoCategoryCreating ? .white : .black)
                        .fixedSize()
                        .font(.title2)
                }
                .padding(.trailing,20)
            }
            //TextField of exercise title
            VStack {
                Divider().overlay(isNoCategoryCreating ? .white : .gray)
                
                TextField("", text: $name)
                
                    .placeholder(when: name.isEmpty) {
                        Text("Title for exercise")
                            .foregroundColor(isNoCategoryCreating ? .gray : Color("GrayColor"))
                    }
                    .padding(10)
                    .foregroundColor(isNoCategoryCreating ? .white : .black)
                    .background(Rectangle()
                        .cornerRadius(viewModel.viewCornerRadiusSimple)
                        .foregroundColor(isNoCategoryCreating ? Color("DarkbackgroundViewColor") : Color("LightGrayColor")))
                    .padding([.top,.bottom], 2)
                
                Divider().overlay(isNoCategoryCreating ? .white : .gray)
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
                    Toggle("", isOn: $doubleWeight)
                        .tint(.green)
                }
                .foregroundColor(isNoCategoryCreating ? Color("MidGrayColor") : Color(.black))
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
                    Toggle("", isOn: $bodyWeight)
                        .tint(.green)
                }
                .foregroundColor(isNoCategoryCreating ? Color("MidGrayColor") : Color(.black))
                Divider().overlay(Color("GrayColor"))
                
                Spacer()
                HStack {
                    Button() {
                        viewModel.isShowedCreateExView.toggle()
                    } label: {
                        Image(systemName: "arrow.left")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(isNoCategoryCreating ? Color("GrayColor") : Color("LightGrayColor"))
                            .tint(isNoCategoryCreating ? .white : .black)
                            .font(.custom("Helvetica", size: viewModel.constW(w:14)))
                            .fontWeight(.bold)
                            .padding(10)
                            .background(Circle())
                            .foregroundColor(Color("MidGrayColor").opacity(isNoCategoryCreating ? 0.1 : 0.5))
                        
                    }
                    Spacer()
                    if name != "" {
                        Button("Create exercise") {
                            HapticManager.instance.impact(style: .medium)
                            if name != "" {
                                let newElement = Exercise(type: typeOfExercise, name: name, doubleWeight: doubleWeight, selfWeight: bodyWeight, isSelected: false, sets: [], isSelectedToAddSet: false)
                                viewModel.createNewExercise(exercise: newElement)
                            }
                            viewModel.isShowedCreateNewExerciseList.toggle()
                            viewModel.isShowedCreateExView.toggle()
                        }
                        .buttonStyle(GrowingButton(isDarkMode: viewModel.isDarkMode,width: viewModel.constW(w:335 - 50),height: viewModel.constH(h:45)))
                        .foregroundColor(Color("DarkGrayColor"))
                    }
                }
                .padding([.leading,.trailing],-5)
            }
            .font(.title2)
            .fontWeight(.bold)
            .padding(20)
            
        }.background(isNoCategoryCreating ? Color("backgroundDarkColor") : .white)
            .onTapGesture {
                self.hideKeyboard()
            }
    }
}

struct CreateNewExercise_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()
        CreateNewExercise(typeOfExercise: .arms, isNoCategoryCreating: false)
    }
}
