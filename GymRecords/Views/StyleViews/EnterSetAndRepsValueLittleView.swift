//
//  EnterSetAndRepsValueLittleView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 16.05.2023.
//

import SwiftUI

struct EnterSetAndRepsValueLittleView: View {
    @EnvironmentObject var viewModel:GymViewModel
    @State var exercise:Exercise
    var screenWidth = UIScreen.main.bounds.width
    @State var notSavedSets:[Sets] = []
    @State var number:Int = 1
    @State var lastSet = Sets(number: 1, date: Date(),weight: 0, reps: 0, doubleWeight: false, selfWeight: false)
    
    var body: some View {
        activeView
    }
    
    var activeView : some View {
        ScrollView {
            VStack {
                ForEach(exercise.sets, id: \.id) { onSet in
                        if viewModel.sameDateCheck(date1: viewModel.selectedDate, date2: onSet.date) {
                            ZStack(alignment: .topTrailing) {
                                EnterOrChangeOneCertainView(weight: onSet.weight, reps: onSet.reps, onSet: onSet, number: onSet.number, exercise: exercise)
                                Button {
                                    HapticManager.instance.impact(style: .medium)
                                    withAnimation(.easeInOut(duration:0.1)) {
                                        viewModel.removelastSet(exercise: exercise)
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color("GrayColor"))
                                        .opacity(0.75)
                                        .tint(.white)
                                        .font(.system(size: 10))
                                }
                                .background(Circle()
                                    .frame(width: 20,height: 20))
                                .foregroundColor(.clear)
                                .offset(x:5,y:-5)
                            }
                        }
                    }
                .padding(.bottom,5)
                    AddSetLittleView(number: viewModel.getNumberAddSetButton(sets: exercise.sets))
                        .onTapGesture {
                            HapticManager.instance.impact(style: .soft)
                            withAnimation(.easeInOut) {
                                viewModel.setsBackUp = exercise.sets
                                
                                exercise = viewModel.createSet(exercise: exercise)
                                
                            }
                        }
                }
            
            .padding(.top,10)
            .frame(width: viewModel.screenWidth)
        }
        
    }
    
    
    
}

struct EnterSetAndRepsValueLittleView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()
        EnterSetAndRepsValueLittleView(exercise: GymModel.arrayOfAllCreatedExercises[0]).environmentObject(GymViewModel())
    }
}
