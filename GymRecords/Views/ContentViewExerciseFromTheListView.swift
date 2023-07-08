//
//  ContentViewExerciseFromTheListView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 12.05.2023.
//

import SwiftUI

struct ContentViewExerciseFromTheListView: View {
    @EnvironmentObject var viewModel:GymViewModel
    
    var exercise:Exercise
    @State var offset:CGFloat = 0
    @State var backgroundColor:Color = .white
    
    var body: some View {
        
        if !viewModel.editMode {
            HStack {
                
                Image(exercise.type.rawValue)
                    .padding([.leading,.trailing], 10)
                Text(exercise.name.capitalized)
                    .fontWeight(.bold)
                    .font(.custom("Helvetica", size: 18))
                Spacer()
                Image(systemName: exercise.isSelectedToAddSet ? "chevron.up" : "chevron.down")
                    .padding([.leading,.trailing], 10)
                    .fontWeight(.medium)
                    .font(.custom("Helvetica", size: 16))
                
            }
            .padding(10)
            
            
        } else {
            ZStack {
                HStack {
                    Image(exercise.type.rawValue)
                        .padding([.leading,.trailing], 10)
                    Text(exercise.name.capitalized)
                        .fontWeight(.bold)
                        .font(.custom("Helvetica", size: 18))
                    Spacer()
                    Image("red-bin-circle")
                        .resizable()
                        .frame(width: 30,height: 30)
                        .padding([.leading,.trailing], 10)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                viewModel.removeExercieFromListOfTrainingInSelectedDay(exercise: exercise)
                            }
                        }
                    
                }
                .background()
                .padding(10)
                .zIndex(2)
                .offset(x:offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            backgroundColor = .red
                            withAnimation(.easeInOut) {
                                self.offset = gesture.translation.width
                                if offset > 50 {
                                    self.offset = 0
                                }
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.easeInOut) {
                                if offset < -120 {
                                    viewModel.removeExercieFromListOfTrainingInSelectedDay(exercise: exercise)
                                    offset = 0
                                    backgroundColor = .white
                                }
                                else if offset > -120 {
                                    offset = 0
                                    backgroundColor = .white
                                }
                            }
                            
                        })
                
                Rectangle().foregroundColor(backgroundColor)
                    .frame(width: viewModel.screenWidth - 20,height: 38)
                    .zIndex(1)
            }
        }
    }
}

struct ContentViewExerciseFromTheListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewExerciseFromTheListView(exercise: .init(type: .arms, name: "Dumbbell Up", doubleWeight: true, selfWeight: false, isSelected: false, sets: [], isSelectedToAddSet: false)).environmentObject(GymViewModel())
    }
}
