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
    @Binding var typeOfExercise:GymModel.TypeOfExercise
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
                
                TextField("Title for exercise:", text: $name)
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
                    Toggle("", isOn: $doubleWeight)
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
                    Toggle("", isOn: $bodyWeight)
                }
                .foregroundColor(Color("MidGrayColor"))
                Divider().overlay(Color("GrayColor"))
                
                Spacer()
                HStack {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica", size: 20))
                            .fontWeight(.bold)
                            .padding()
                            .background(Circle())
                            .foregroundColor(Color("MidGrayColor").opacity(0.1))
                        
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
                        .buttonStyle(GrowingButton(isDarkMode: true,width: 335 - 50,height: 45))
                        .foregroundColor(Color("DarkGrayColor"))
                    }
                }
                .padding([.leading,.trailing],name != "" ? 20 : 2)
            }
            .font(.title2)
            .fontWeight(.bold)
            .padding(20)
        }.background(Color("backgroundColor"))
    }
}

struct CreateNewExercise_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewExercise(typeOfExercise: .constant(.arms), showView: .constant(true)).environmentObject(GymViewModel())
    }
}
