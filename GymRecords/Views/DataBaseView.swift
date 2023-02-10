//
//  DataBaseView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 09.02.2023.
//

import SwiftUI

struct DataBaseView: View {
    @EnvironmentObject var viewModel:GymViewModel
    
    var body: some View {
        VStack {
            VStack{
                HStack{
                    Text("Database")
                    
                    Spacer()
                    Button{
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(viewModel.systemColorMidGray)
                            .font(.custom("Helvetica", size: 16))
                    }
                }
                .padding([.leading,.trailing],30)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top,20)
                DataBaseInfoTitle().environmentObject(viewModel)
                .padding(5)
            }
            ExercisesAndProgramsListView().environmentObject(viewModel)
        }
    }
}

struct DataBaseView_Previews: PreviewProvider {
    static var previews: some View {
        DataBaseView().environmentObject(GymViewModel())
    }
}
