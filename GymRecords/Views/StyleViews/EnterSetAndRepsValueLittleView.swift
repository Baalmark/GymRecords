//
//  EnterSetAndRepsValueLittleView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 16.05.2023.
//

import SwiftUI

struct EnterSetAndRepsValueLittleView: View {
    @EnvironmentObject var viewModel:GymViewModel
    var exercise:Exercise
    var screenWidth = UIScreen.main.bounds.width
    @State var enterWeightTextField:Double = 0
    @State var enterRepsTextField:Double = 0
    var isActiveView:Bool
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    
    var body: some View {
        
        if isActiveView {
            activeView
        } else {
            inActiveView
        }
    }
    
    var activeView : some View {
        
        ForEach(exercise.sets) { onSet in
            HStack {
                Text("\(onSet.number)")
                    .padding(.leading,-15)
                    .font(.callout.bold())
                    .foregroundColor(Color("MidGrayColor"))
                HStack {
                    TextField("\(onSet.weight)",value: $enterWeightTextField,formatter: numberFormatter)
                        .onAppear {
                            enterWeightTextField = onSet.weight
                        }
                        .font(.custom("Helvetica", size: 24).bold())
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(height: 70)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("LightGrayColor")))
                    TextField("\(onSet.weight)",value: $enterRepsTextField,formatter: numberFormatter)
                        .onAppear {
                            enterRepsTextField = onSet.reps
                        }
                        .font(.custom("Helvetica", size: 24).bold())
                        .foregroundColor(onSet.reps == 0 ? .clear : .black)
                        .frame(height: 70)
                        .multilineTextAlignment(.center)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("LightGrayColor")))
                    
                }
                .frame(width: screenWidth - 60,height: 70)
            }
        }
    }
    var inActiveView: some View {
        ForEach(exercise.sets) { onSet in
            HStack {
                Text("\(onSet.number)")
                    .padding(.leading,-15)
                    .font(.callout.bold())
                    .foregroundColor(Color("MidGrayColor"))
                HStack {
                    TextField("\(onSet.weight)",value: $enterWeightTextField,formatter: numberFormatter)
                        .onAppear {
                            enterWeightTextField = onSet.weight
                        }
                        .font(.custom("Helvetica", size: 24).bold())
                        .foregroundColor(onSet.weight == 0 ? .clear : .black)
                        .frame(height: 70)
                        .multilineTextAlignment(.center)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("LightGrayColor")))
                    TextField("\(onSet.weight)",value: $enterRepsTextField,formatter: numberFormatter)
                        .onAppear {
                            enterRepsTextField = onSet.reps
                        }
                        .font(.custom("Helvetica", size: 24).bold())
                        .foregroundColor(onSet.reps == 0 ? .clear : .black)
                        .frame(height: 70)
                        .multilineTextAlignment(.center)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("LightGrayColor")))
                    
                }
                .frame(width: screenWidth - 60,height: 70)
            }
        }
    }
}

struct EnterSetAndRepsValueLittleView_Previews: PreviewProvider {
    static var previews: some View {
        EnterSetAndRepsValueLittleView(exercise: GymModel.arrayOfAllCreatedExercises[0],isActiveView: false)
    }
}
