//
//  DataBaseInfoTitle.swift
//  GymRecords
//
//  Created by Pavel Goldman on 09.02.2023.
//

import SwiftUI

struct DataBaseInfoTitle: View {
    @EnvironmentObject var viewModel:GymViewModel
    
    var body: some View {
        HStack {
            ForEach(viewModel.databaseInfoTitle.indices,id:\.self) {element in
                VStack{
                    Text("\(viewModel.databaseInfoTitle[element].1)")
                        .font(.custom("Helvetica", size: 20))
                    Text("\(viewModel.databaseInfoTitle[element].0)")
                        .font(.custom("Helvetica", size: 14))
                    
                }
                
                .fontWeight(.bold)
                .background(RoundedRectangle(cornerRadius: 15)
                    .frame(width: viewModel.screenWidth / 3.3,height: 50)
                    .foregroundColor(Color("MidGrayColor")))
                .padding([.leading,.trailing],25)
                
                
            }
            
        }
    }
}

struct DataBaseInfoTitle_Previews: PreviewProvider {
    static var previews: some View {
        DataBaseInfoTitle().environmentObject(GymViewModel())
    }
}
