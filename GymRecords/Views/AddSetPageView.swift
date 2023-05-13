//
//  AddSetPageView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 13.05.2023.
//

import SwiftUI

struct AddSetPageView: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    @State var exercises = GymModel.arrayOfAllCreatedExercises
    var body: some View {
        TabView {
            ForEach(exercises) { exercise in
                ZStack {
                    Color.accentColor
                    VStack(alignment:.leading) {
                        Text("Row: \(exercise.name)").foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                }

                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                
                .padding([.leading,.trailing],5)
                .frame(width: viewModel.screenWidth)
            }

        }
        .frame(width: viewModel.screenWidth)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

struct AddSetPageView_Previews: PreviewProvider {
    static var previews: some View {
        AddSetPageView().environmentObject(GymViewModel())
    }
}
