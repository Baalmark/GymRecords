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
                        VStack(alignment: .leading){
                            Text("\(exercise.name)").foregroundColor(.black)
                                .font(.custom("Helvetica", size: 24).bold())
                                .padding(-3).padding(.leading,20)
                            HStack {
                                Text("weight")
                                    .padding(.trailing,110)
                                Text("reps")
                            }
                            .padding(7.6).padding(.leading,16)
                            .padding(.top,15).padding(.leading,5)
                            .font(.callout.bold())
                            .foregroundColor(Color("MidGrayColor"))
                            if !exercise.sets.isEmpty {
                                ScrollView {
                                    VStack {
                                        DisplaySetsMainView(exercise: exercise)
                                            .padding([.leading,.trailing])
                                            .onTapGesture {
                                                withAnimation(.easeInOut) {
                                                    viewModel.didTapToAddSet.toggle()
                                                    viewModel.crntExrcsFrEditSets = exercise
                                                    viewModel.setsBackUp = viewModel.crntExrcsFrEditSets.sets
                                                }
                                            }
                                    }
                                    .frame(width: viewModel.screenWidth)
                                }
                            }
                            AddSetLittleView(number: viewModel.getNumberAddSetButton(sets: exercise.sets))
                                
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        
                                        viewModel.didTapToAddSet.toggle()
                                        viewModel.crntExrcsFrEditSets = exercise
                                        viewModel.crntExrcsFrEditSets = viewModel.createSet(exercise: viewModel.crntExrcsFrEditSets)
                                        viewModel.setsBackUp = viewModel.crntExrcsFrEditSets.sets
                                    }
                                }
                            Spacer()
                        }
                        .frame(width: viewModel.screenWidth,height: viewModel.constH(h: 600))
                        .padding(.top, 80)
                        HStack {
                            Button {
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
                    .overlay{
                        if viewModel.didTapToAddSet {
                            
                            AddOrChangeSetView(exercise: viewModel.crntExrcsFrEditSets)
                                .gesture(DragGesture()
                                    .onChanged { value in
                                    }
                                    .onEnded { value in
                                    })
                                .ignoresSafeArea(.all)
                                .onAppear {
                                    viewModel.blurOrBlackBackground = false
                                }
                                .onDisappear {
                                    viewModel.blurOrBlackBackground = true
                                }
                            
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    .frame(width: viewModel.screenWidth)
                    .tag(index)
                
            }
            
        }
        
        .frame(width: viewModel.screenWidth + 20,height: viewModel.screenHeight)
        .padding([.leading,.trailing],-10)
        .ignoresSafeArea(.all)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
        if viewModel.willAppearStatisticView {
            if let exercise = viewModel.selectedExerciseForStatisticView{
                
                let weight = viewModel.weightGraphDataGetter(exercise: exercise)
                let reps  = viewModel.repsGraphDataGetter(exercise: exercise)
                
                StatistisView(exercise: exercise,reps:reps, weight:weight)
                    .transition(.move(edge: .bottom))
            }
                
        }
        
        
    }
    
}

struct AddSetPageView_Previews: PreviewProvider {
    static var previews: some View {
        let migrator = Migrator()
        
        AddSetPageView(scrollToIndex: 0).environmentObject(GymViewModel())
    }
}
