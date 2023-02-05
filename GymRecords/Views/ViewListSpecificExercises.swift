//
//  ViewListSpecificExercises.swift
//  GymRecords
//
//  Created by Pavel Goldman on 01.02.2023.
//

import SwiftUI

struct ViewListSpecificExercises: View {
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    
    var typeOfExercise:GymModel.TypeOfExercise
    @Binding var isPresented: Bool
    @State var isTappedToggle = false
    
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
            VStack{
                ForEach(viewModel.arrayExercises.indices,id:\.self) { id in
                    //                if id.type == self.typeOfExercise {
                    HStack {
                        if viewModel.arrayExercises[id].type == typeOfExercise {
                            //                        ExerciseToggle(exerciseTitle: viewModel.arrayExercises[id].name, exerciseIsOn: viewModel.arrayExercises[id].isSelected)
                            ExerciseToggle(exercise:viewModel.arrayExercises[id], toggle: false)
                        }
                    }
                    
                    .padding([.leading,.trailing],30)
                    .padding(.top,30)
                    
                }
            }
            Spacer()
            
            Button{
                viewModel.clearArrayOfSelectedExercises()
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
    
    @EnvironmentObject var viewModel:GymViewModel
    var exercise:Exercise
    @State var toggle:Bool
        var body: some View {
            VStack(spacing: 0) {
                Toggle(exercise.name, isOn: $toggle)
                    .font(.custom("Helvetica",size: 22))
                    .fontWeight(.bold)
                    .onChange(of: toggle) { elem in
                        if elem == true {
                            print("Im goin to true")
                            viewModel.selectingExercise(exercise: exercise, isSelected: toggle)
                        } else {
                            print("Im to false")
                            viewModel.unselectingExercise(exercise: exercise, isSelected: toggle)
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
            Image(systemName: configuration.isOn ? "checkmark" : "square.fill")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(configuration.isOn ? .black : .white)
                .font(.custom("Helvetica", size: 22))
                
        }
        .onTapGesture { configuration.isOn.toggle()}

    }
}












struct ViewListSpecificExercises_Previews: PreviewProvider {
    static var previews: some View {
        ViewListSpecificExercises(typeOfExercise: .cardio,isPresented: .constant(true)).environmentObject(GymViewModel())
    }
}
