//
//  DragGestureLineView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 06.05.2023.
//

import SwiftUI

struct DragGestureLineView: View {
    @EnvironmentObject var viewModel:GymViewModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 50)
            .frame(width: viewModel.screenWidth,height: 25)
    }
}

struct DragGestureLineView_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureLineView().environmentObject(GymViewModel())
    }
}
