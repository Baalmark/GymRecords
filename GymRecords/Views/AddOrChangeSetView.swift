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
    @State var toAddSet:Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Button {
                withAnimation(.easeInOut) {
                    viewModel.didTapToAddSet = false
                    exercise.sets = viewModel.setsBackUp
                }
                
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(Color("GrayColor"))
                    .tint(.black)
                    .fixedSize()
                    .font(.title)
            }
            .offset(x:viewModel.screenWidth - 45)
            
            Text("\(exercise.name)").foregroundColor(.white)
                .font(.custom("Helvetica", size: 24).bold())
                .padding(20)
            
            HStack {
                Text("weight")
                    .padding(.trailing,110)
                Text("reps")
            }
            .padding(.leading,30)
            .font(.callout.bold())
            .foregroundColor(Color("MidGrayColor"))
            EnterSetAndRepsValueLittleView(exercise: exercise,toAddSet: toAddSet).environmentObject(viewModel)
                .onAppear {
                    viewModel.setsBackUp = exercise.sets
                }
                .ignoresSafeArea(.keyboard)
            
                
            Spacer()
            Button("Save") {
                withAnimation(.easeInOut) {
                    viewModel.didTapToAddSet = false
                    viewModel.crntExrcsFrEditSets = exercise
                    
                    
                }
                
            }
            .buttonStyle(GrowingButton(isDarkMode: false,width: 335,height: 45))
            .tint(.white)
            .font(.title2)
            .fontWeight(.semibold)
            .padding([.leading,.trailing],30)
            
            .offset(y:-5)
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        
        
        
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .padding(.top, 20)
        .padding([.leading,.trailing],5)
        .frame(width: viewModel.screenWidth)
        .background(Color("backgroundDarkColor"))
        
        .ignoresSafeArea(.all)
        
    }
    
    
}

struct AddOrChangeSetView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrChangeSetView(exercise: .init(type: .body, name: "Test", doubleWeight: true, selfWeight: true, isSelected: false, sets: GymModel.testSets, isSelectedToAddSet: true), toAddSet: true).environmentObject(GymViewModel())
    }
}
