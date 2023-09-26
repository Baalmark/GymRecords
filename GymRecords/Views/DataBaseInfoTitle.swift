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
                        .font(.custom("Helvetica", size: viewModel.constW(w:20)))
                    Text("\(viewModel.databaseInfoTitle[element].0)")
                        .font(.custom("Helvetica", size: viewModel.constW(w:14)))
                    
                }
                .fontWeight(.bold)
                    .frame(width: viewModel.constW(w:viewModel.screenWidth / 3 - 15),height: viewModel.constH(h:50))
                .background(RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("LightGrayColor")))
                
            }
            
        }
        .frame(width: viewModel.screenWidth)
        
    }
}

struct DataBaseInfoTitle_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()
        DataBaseInfoTitle().environmentObject(GymViewModel())
    }
}
