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
                            ScrollView {
                                VStack {
                                        DisplaySetsMainView(exercise: exercise)
                                        .padding(.leading,-2).padding(.top, -3).padding(.bottom,6)
                                        .onTapGesture {
                                            withAnimation(.easeInOut) {
                                                viewModel.didTapToAddSet.toggle()
                                                viewModel.crntExrcsFrEditSets = exercise
                                                viewModel.setsBackUp = viewModel.crntExrcsFrEditSets.sets
                                            }
                                        }

                                    AddSetLittleView(number: exercise.sets.count + 1)
                                        .padding(.leading,-4).padding(.top, -3).padding(.bottom,6)
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
                                .frame(width: viewModel.screenWidth)
                            }
                        }
                        .frame(width: viewModel.screenWidth,height: 600)
                        .padding(.top, 80)
                        Spacer()
                        HStack {
                            Button {
                            }
                            label: {
                                HStack {
                                    Image(systemName: "chart.bar.xaxis")
                                    Text("Statistics")
                                }
                            }
                            .background(Capsule(style: .continuous).frame(width: viewModel.screenWidth / 2 - 20,height: 45).foregroundColor(.black))
                            .tint(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .offset(x:-65,y:700)
                            Button("Done") {
                                withAnimation {
                                    viewModel.isShowedMainAddSetsView.toggle()
                                    
                                }
                            }
                            .background(Capsule(style: .continuous).frame(width: viewModel.screenWidth / 2 - 20,height: 45).foregroundColor(.black))
                            .tint(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .offset(x: 25,y:700)
                        }.padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                    .frame(width: viewModel.screenWidth)
                    .tag(index)
                
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
        }
        
        .frame(width: viewModel.screenWidth + 20)
        .padding([.leading,.trailing],-10)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
        
    }
    
}

struct AddSetPageView_Previews: PreviewProvider {
    static var previews: some View {
        AddSetPageView(scrollToIndex: 0).environmentObject(GymViewModel())
    }
}
