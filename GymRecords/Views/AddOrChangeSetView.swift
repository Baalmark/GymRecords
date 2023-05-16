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
    @State var number:Int = 1
    var body: some View {
        VStack(alignment: .leading){
            Text("\(exercise.name)").foregroundColor(.white)
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
            EnterSetAndRepsValueLittleView(exercise: exercise, isActiveView: true)
                .padding(.leading,25)
                .onAppear {
                     number = exercise.sets.count + 1
                }
            AddSetLittleView(number: number)
                .frame(width: viewModel.screenWidth)
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)

        
        .onTapGesture {
            withAnimation(.easeInOut) {
                viewModel.didTapToAddSet = false
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        
        .padding([.leading,.trailing],5)
        .frame(width: viewModel.screenWidth)
        .background(Color("backgroundDarkColor"))
        .ignoresSafeArea(.all)
    }
    
}

struct AddOrChangeSetView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrChangeSetView(exercise: .init(type: .body, name: "Test", doubleWeight: true, selfWeight: true, isSelected: false, sets: GymModel.testSets, isSelectedToAddSet: true)).environmentObject(GymViewModel())
    }
}
