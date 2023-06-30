//
//  AddNewSetsMainView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 12.05.2023.
//

import SwiftUI

struct AddNewSetsMainView: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    

    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: true) {
            
            AddSetPageView()
                    
                
            }
            .frame(width: viewModel.screenWidth)
        }


    var widthOfFrame: CGFloat
    {
        let count =  CGFloat(viewModel.trainInSelectedDay.exercises.count)
        let width = viewModel.screenWidth
        let padding = CGFloat(viewModel.trainInSelectedDay.exercises.count * 10)

        return width * count + padding
    }

}


    struct AddNewSetsMainView_Previews: PreviewProvider {
        static var previews: some View {
            AddNewSetsMainView().environmentObject(GymViewModel())
        }
    }
