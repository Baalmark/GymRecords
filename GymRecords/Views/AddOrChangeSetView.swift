//
//  AddOrChangeSetView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 16.05.2023.
//

import SwiftUI

struct AddOrChangeSetView: View {
    @EnvironmentObject var viewModel:GymViewModel
    @State var exercise:Exercise
    //NEED TO COMMIT 
    var body: some View {
        VStack(alignment: .leading){
        
            HStack {
                Text("\(exercise.name)").foregroundColor(.white)
                    .font(.custom("Helvetica", size: 24).bold())
                    .padding(30)
                Spacer()
                Button {
                    withAnimation(.easeInOut) {
                        viewModel.didTapToAddSet = false
                        exercise.sets = viewModel.setsBackUp
                        
                        if !exercise.sets.isEmpty {
                            let filteredSets = exercise.sets.filter { Set in
                                Set.reps != 0 || Set.weight != 0
                            }
                            exercise.sets = filteredSets
                        }
                    }
                    
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(Color("GrayColor"))
                        .tint(Color("backgroundDarkColor"))
                        .fixedSize()
                        .font(.title)
                }
                .padding(.trailing,20)
            }
            .padding(.top,20)
            HStack {
                Text(exercise.type == .cardio ? "km/h" : "weight")
                    .padding(.trailing,110)
                Text(exercise.type == .stretching || exercise.type == .cardio ? "mins" : "reps")
            }
            .padding(.leading,30)
            .font(.callout.bold())
            .foregroundColor(Color("MidGrayColor"))
            
            EnterSetAndRepsValueLittleView(exercise: exercise)
                
                .ignoresSafeArea(.keyboard)
            
                
            Spacer()
            Button("Save") {
                withAnimation(.easeInOut) {
                    
                    if !exercise.sets.isEmpty {
                        let filteredSets = exercise.sets.filter { Set in
                            Set.reps != 0 || Set.weight != 0
                        }
                        exercise.sets = filteredSets
                    }
                    viewModel.saveEditedExercise(exercise: exercise,newSets: exercise.sets)
                    viewModel.didTapToAddSet = false
                    viewModel.crntExrcsFrEditSets = Exercise(type: .arms, name: "nil", doubleWeight: false, selfWeight: false, isSelected: false, sets: [], isSelectedToAddSet: false)
                    viewModel.setsBackUp = []
                }
                
            }
            .buttonStyle(GrowingButton(isDarkMode: false,width: viewModel.constW(w:335),height: viewModel.constH(h:45)))
            .tint(.white)
            .font(.title2)
            .fontWeight(.semibold)
            .padding(30)
            
            .offset(y:viewModel.constH(h:-5))
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        
        
        
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .padding(.top, 30)
        .padding([.leading,.trailing],5)
//MARK: TO CHECK
        .frame(width: viewModel.screenWidth)
        .background(Color("backgroundDarkColor"))
        
        .ignoresSafeArea(.all)
        .preferredColorScheme(.dark)
    }
    
    
    
}

struct AddOrChangeSetView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()
        
        AddOrChangeSetView(exercise: .init(type: .abs, name: "", doubleWeight: true, selfWeight: true, isSelected: false, sets: [], isSelectedToAddSet: true)).environmentObject(GymViewModel())
    }
}
