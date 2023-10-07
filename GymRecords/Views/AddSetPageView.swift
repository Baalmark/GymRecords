//
//  AddSetPageView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 13.05.2023.
//

import SwiftUI

struct AddSetPageView: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @State var scrollToIndex:Int
    var body: some View {
        TabView(selection:$scrollToIndex) {
            ForEachIndex(viewModel.trainInSelectedDay.exercises){ index,
                exercise in
                    ZStack(alignment:.top) {
                        Color.white
                        VStack(alignment: .center){
                            Text("\(exercise.name)").foregroundColor(Color("backgroundDarkColor"))
                                .font(.custom("Helvetica", size: 24).bold())
                                .padding(.leading, !exercise.sets.isEmpty ? 30 : 0)
                            if !exercise.sets.isEmpty {
                                HStack {
                                    Text(exercise.type == .cardio ? "km/h" : "weight")
                                        .padding(.trailing,110)
                                    Text(exercise.type == .stretching || exercise.type == .cardio ? "mins" : "reps")
                                }
                                .padding(10).padding(.leading,20)
                                .padding(.top,18)
                                .font(.callout.bold())
                                .foregroundColor(Color("MidGrayColor"))
                                
                                ScrollView {
                                    VStack {
                                        DisplaySetsMainView(exercise: exercise)
                                            .padding([.leading,.trailing])
                                            .onTapGesture {
                                                HapticManager.instance.impact(style: .soft)
                                                withAnimation(.easeInOut) {
                                                    viewModel.didTapToAddSet.toggle()
                                                    viewModel.crntExrcsFrEditSets = exercise
                                                    viewModel.setsBackUp = viewModel.crntExrcsFrEditSets.sets
                                                }
                                            }
                                        AddSetLittleView(number: viewModel.getNumberAddSetButton(sets: exercise.sets))
                                            .onTapGesture {
                                                HapticManager.instance.impact(style: .soft)
                                                withAnimation(.easeInOut) {
                                                    
                                                    viewModel.didTapToAddSet.toggle()
                                                    viewModel.crntExrcsFrEditSets = exercise
                                                    viewModel.crntExrcsFrEditSets = viewModel.createSet(exercise: viewModel.crntExrcsFrEditSets)
                                                    viewModel.setsBackUp = viewModel.crntExrcsFrEditSets.sets
                                                }
                                            }
                                    }
                                    .frame(width: viewModel.screenWidth)
                                }
                            } else {
                                
                                AddSetLittleView(number: viewModel.getNumberAddSetButton(sets: exercise.sets))
                                    .padding(.top,65)
                                    .onTapGesture {
                                        HapticManager.instance.impact(style: .soft)
                                        withAnimation(.easeInOut) {
                                            
                                            viewModel.didTapToAddSet.toggle()
                                            viewModel.crntExrcsFrEditSets = exercise
                                            viewModel.crntExrcsFrEditSets = viewModel.createSet(exercise: viewModel.crntExrcsFrEditSets)
                                            viewModel.setsBackUp = viewModel.crntExrcsFrEditSets.sets
                                        }
                                    }
                                Spacer()
                            }
                        }
                        .frame(width: viewModel.screenWidth,height: viewModel.constH(h: 600))
                        .padding(.top, 20)
                            
                        HStack {
                            Button {
                                HapticManager.instance.impact(style: .medium)
                                withAnimation(.easeIn(duration: 0.5)) {
                                    viewModel.willAppearStatisticView.toggle()
                                    viewModel.selectedExerciseForStatisticView = exercise
                                }
                            }
                            label: {
                                HStack {
                                    Image(systemName: "chart.bar.xaxis")
                                    Text("Statistics")
                                }
                            }
                            .buttonStyle(GrowingButton(isDarkMode: false,width: viewModel.screenWidth / 2 - 20,height: 45))
                            .tint(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .offset(x: 0,y:viewModel.constH(h: 700))
                            Button("Done") {
                                HapticManager.instance.impact(style: .light)
                                withAnimation {
                                    viewModel.isShowedMainAddSetsView.toggle()
                                    
                                }
                            }
                            .buttonStyle(GrowingButton(isDarkMode: false,width: viewModel.screenWidth / 2 - 20,height: 45))
                            .tint(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .offset(x: 0,y:viewModel.constH(h: 700))
                        }
                    }
                    .fullScreenCover(isPresented: $viewModel.didTapToAddSet) {
                            AddOrChangeSetView(exercise: viewModel.crntExrcsFrEditSets)
                                .gesture(DragGesture()
                                    .onChanged { value in
                                    }
                                    .onEnded { value in
                                    })
                                .onAppear {
                                    viewModel.blurOrBlackBackground = false
                                }
                                .onDisappear {
                                    viewModel.blurOrBlackBackground = true
                                }
                        
                        }

                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    .frame(width: viewModel.screenWidth)
                    .tag(index)
            }
        }
        
        .frame(width: viewModel.screenWidth + 20,height: viewModel.screenHeight)
        .padding([.leading,.trailing],-10)
//        .ignoresSafeArea(.all)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .sheet(isPresented: $viewModel.willAppearStatisticView) {
            if let exercise = viewModel.selectedExerciseForStatisticView{
                
                let weight = viewModel.weightGraphDataGetter(exercise: exercise)
                let reps  = viewModel.repsGraphDataGetter(exercise: exercise)
                
                StatistisView(exercise: exercise,reps:reps, weight:weight)
                
            }}
    }
    
}

struct AddSetPageView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()
        
        AddSetPageView(scrollToIndex: 0).environmentObject(GymViewModel())
    }
}
