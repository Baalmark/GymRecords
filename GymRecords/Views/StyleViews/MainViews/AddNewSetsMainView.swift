//
//  AddNewSetsMainView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 12.05.2023.
//

import SwiftUI

struct AddNewSetsMainView: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    var scrollToIndex:Int

    
    var body: some View {
                AddSetPageView(scrollToIndex: scrollToIndex)
            .frame(width: viewModel.screenWidth)
    }
}


    struct AddNewSetsMainView_Previews: PreviewProvider {
        static var previews: some View {
            let _ = Migrator()

            AddNewSetsMainView(scrollToIndex: 0).environmentObject(GymViewModel())
        }
    }
