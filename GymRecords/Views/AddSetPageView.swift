//
//  AddSetPageView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 13.05.2023.
//

import SwiftUI

struct AddSetPageView: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    @State var exercises:[Exercise]
    @State var countOfLittleViews = 0
    var body: some View {
        TabView {
            ForEach(exercises) { exercise in
                ZStack(alignment:.top) {
                    Color.white
                    RoundedRectangle(cornerRadius: 5).frame(width: viewModel.screenWidth,height: 30)
                    VStack(alignment: .leading){
                        
                        Text("\(exercise.name)").foregroundColor(.black)
                            .font(.custom("Helvetica", size: 24).bold())
                            .padding(.bottom,20)
                        HStack {
                            Text("weight")
                                .padding(.trailing,120)
                            Text("reps")
                        }
                        .padding(.top,15).padding(.leading,5)
                        .font(.callout.bold())
                        .foregroundColor(Color("MidGrayColor"))
                        
                        EnterSetAndRepsValueLittleView(exercise: exercise, isActiveView: false).environmentObject(viewModel)
                            
                        
                           
                        AddSetLittleView(number: countOfLittleViews + 1)
                            
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    viewModel.didTapToAddSet.toggle()
                                }
                            }
                        Spacer()
                    }
                    .padding(.top, 80)
                    if viewModel.didTapToAddSet {
                        
                        AddOrChangeSetView(exercise: exercise)
                            .zIndex(1)
                            
                        
                    }
                    
                }
                
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                
                
                .frame(width: viewModel.screenWidth)
                
            }
            
            
        }
        .frame(width: viewModel.screenWidth)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

struct AddSetPageView_Previews: PreviewProvider {
    static var previews: some View {
        AddSetPageView(exercises: GymModel.arrayOfAllCreatedExercises).environmentObject(GymViewModel())
    }
}
