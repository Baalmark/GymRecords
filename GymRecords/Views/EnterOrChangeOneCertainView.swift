//
//  EnterOrChangeOneCertainView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 17.05.2023.
//

import SwiftUI

struct EnterOrChangeOneCertainView: View {
    @EnvironmentObject var viewModel:GymViewModel
    @State var weight:Double
    @State var reps:Double
    @State var onSet:Sets
    @State var number:Int
    @State var exercise:Exercise
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()

    var body: some View {
        HStack {
            Text("\(number)")
                .padding(.leading,-15)
                .font(.callout.bold())
                .foregroundColor(Color("MidGrayColor"))
            HStack {
                TextField("weight",value: $weight,formatter: numberFormatter)
                    .onAppear {
                        weight = onSet.weight
                    }
                    .onChange(of:weight) { newValue in
                        onSet.weight = newValue
                        print(newValue)
                        exercise =  viewModel.saveSetInEx(set: onSet, exercise: exercise)
                        
                    }
                    .font(.custom("Helvetica", size: 24).bold())
                    .foregroundColor(.black)
                    
                    .multilineTextAlignment(.center)
                    .frame(height: 70)
                    .background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color("LightGrayColor")))
                TextField("reps",value: $reps,formatter: numberFormatter)
                    .onAppear {
                        reps = onSet.reps
                    }
                    .onChange(of:reps) { newValue in
                        onSet.reps = newValue
                       
                        exercise =  viewModel.saveSetInEx(set: onSet, exercise: exercise)

                        
                    }
                    
                    .font(.custom("Helvetica", size: 24).bold())
                    .foregroundColor(.black)
                    .frame(height: 70)
                    .multilineTextAlignment(.center)
                    .background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color("LightGrayColor")))
                
            }
            
            .frame(width: viewModel.screenWidth - 60,height: 70)
        }
    }
}

struct EnterOrChangeOneCertainView_Previews: PreviewProvider {
    static var previews: some View {
        let migrator = Migrator()

        EnterOrChangeOneCertainView(weight: 10, reps: 10 ,onSet: .init(number: 1, weight: 10, reps: 1, doubleWeight: true, selfWeight: false), number: 1, exercise: GymModel.arrayOfAllCreatedExercises[0]).environmentObject(GymViewModel())
    }
}
