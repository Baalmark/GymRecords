//
//  ViewListSpecificExercises.swift
//  GymRecords
//
//  Created by Pavel Goldman on 01.02.2023.
//

import SwiftUI

struct ViewListSpecificExercises: View {
    
    var viewModel = GymViewModel()
    @Environment(\.dismiss) var dismiss
    var typeOfExercise:GymModel.TypeOfExercise
    @Binding var isPresented: Bool
    
    
    var body: some View {
        VStack(alignment:.leading){
//Title and Button Create Exercise
            Text("\(typeOfExercise.rawValue.capitalized)")
                .padding([.leading,.top],30)
                .font(.custom("Helvetica", size: 24))
                .fontWeight(.bold)
            HStack{
                Text("Create Exercise")
                    .font(.custom("Helvetica", size: 22))
                    .fontWeight(.bold)
                Spacer()
                Button("+") {
                    //
                }
                .foregroundColor(.black)
                .font(.custom("Helvetica", size: 26))
                .fontWeight(.bold)
                .padding(.trailing,10)
            }
            .padding(20)
            .background(Rectangle()
                .foregroundColor(viewModel.systemColorLightGray)
                .frame(width: viewModel.screenWidth - 20, height: 60)
                .cornerRadius(10))
            .padding(10)
            
            ForEach(viewModel.arrayExercises,id:\.self) { elem in
                if elem.type == self.typeOfExercise {
                    
                    HStack {
                        
                        ExerciseToggle(exerciseTitle: elem.name)
                    }
                    .padding([.leading,.trailing],30)
                    .padding(.top,30)
                    
                }
            }
            Spacer()
            
            Button{
                
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
            }
            .font(.custom("Helvetica", size: 26))
            .foregroundColor(.white)
            .background(Circle()
                .foregroundColor(viewModel.systemColorGray)
                .frame(width: 40,height: 40,alignment: .center)
            )
            .padding([.leading,.bottom],40)
            
            }
//Turn on all of animation
        .onDisappear {
                    UIView.setAnimationsEnabled(true)    // << here !!
                }
        .interactiveDismissDisabled()
        }
    }






//Toggle for every Exercise
struct ExerciseToggle: View {
    
    var viewModel = GymViewModel()
    var exerciseTitle: String
    
    @State var arrayOfToggles:[GymModel.Exercise] = []
    @State var exerciseToggle = false
        
        var body: some View {
            VStack(spacing: 0) {
                Toggle(exerciseTitle, isOn: $exerciseToggle)
                    .font(.custom("Helvetica",size: 22))
                    .fontWeight(.bold)
                    .onChange(of: exerciseToggle) { elem in
                        
                        if let temp = viewModel.findExerciseByTitle(title:exerciseTitle) {
                            viewModel.appendToArrayOfSelectedExercises(name: temp.name, type: temp.type)
                            
                        }
                        
                    }
                    
            }
            .toggleStyle(CheckboxStyle())
            .padding(.horizontal)
        }
    }



//Toggle Style
struct CheckboxStyle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark" : "")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(configuration.isOn ? .black : .gray)
                .font(.custom("Helvetica", size: 22))
                
        }
        .onTapGesture { configuration.isOn.toggle()}

    }
}












struct ViewListSpecificExercises_Previews: PreviewProvider {
    static var previews: some View {
        ViewListSpecificExercises(typeOfExercise: .cardio,isPresented: .constant(true))
    }
}
