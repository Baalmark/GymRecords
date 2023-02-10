//
//  EditOrRemoveTheProgramm.swift
//  GymRecords
//
//  Created by Pavel Goldman on 10.02.2023.
//

import SwiftUI

struct EditOrRemoveTheProgram: View {
    var body: some View {
        VStack(alignment:.leading){
            Text("Programm")
                .padding([.leading,.trailing],30)
                .font(.title)
                .fontWeight(.bold)
                .offset(x:-110,y:0)
                .padding(.top,20)
                
            Spacer()
        }
        
    }
}

struct EditOrRemoveTheProgramm_Previews: PreviewProvider {
    static var previews: some View {
        EditOrRemoveTheProgram()
    }
}
