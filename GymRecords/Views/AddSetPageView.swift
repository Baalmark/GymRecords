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
                ZStack(alignment:.leading) {
                    Color.white
                    VStack(alignment: .leading){
                        Text("\(exercise.name)").foregroundColor(.black)
                            .font(.custom("Helvetica", size: 24).bold())
                            .padding(25)
                        HStack {
                            Text("weight")
                                .padding(.trailing,150)
                            Text("reps")
                        }
                        .padding([.leading,.bottom],35)
                        .font(.callout.bold())
                        .foregroundColor(Color("MidGrayColor"))
                        
                        EnterSetAndRepsValueLittleView(exercise: exercise, isActiveView: true).environmentObject(viewModel)
                            .padding(.leading,20)
                        
                           
                        AddSetLittleView(number: countOfLittleViews + 1)
                            .padding(.leading,25)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    viewModel.didTapToAddSet.toggle()
                                }
                            }
                        Spacer()
                    }
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
