//
//  EditOrRemoveTheProgramm.swift
//  GymRecords
//
//  Created by Pavel Goldman on 10.02.2023.
//

import SwiftUI

struct EditOrRemoveTheProgram: View {
    
    @EnvironmentObject var viewModel:GymViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var program:GymModel.Program
    @State var showSheet:Bool = false
    
    var body: some View {
        VStack(alignment:.leading){
            Text("Program")
                .padding([.leading,.trailing],40)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top,20)
            
            ProgramItemListView(programm: $program)
            VStack {
                ForEach(program.exercises,id: \.id) { elem in
                    HStack {
                        
                        Image(elem.type.rawValue)
                            .padding(.leading,20)
                        Text(elem.name.capitalized)
                            .padding(.leading,10)
                            .frame(width: 300,height: 50,alignment: .leading)
                            .foregroundColor(.black)
                            .font(.custom("Helvetica", size: 20))
                            .fontWeight(.bold)
                    }
                    .padding(.leading,20)
                }
                
            }
            Spacer()
            
            HStack {
                //Back button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .padding(10)
                }
                .font(.custom("Helvetica", size: 20))
                .background(Circle()
                    .frame(width: 40,height: 40)
                    .foregroundColor(Color("MidGrayColor")))
                .padding(.leading,15)
                //Edit or Remove
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding(10)
                }
                .font(.custom("Helvetica", size: 20))
                .background(Circle()
                    .frame(width: 40,height: 40)
                    .foregroundColor(Color("MidGrayColor")))
                .sheet(isPresented: $showSheet) {
                    VStack {
                        Capsule()
                            .fill(.gray)
                            .frame(width: 45, height: 5)
                            .offset(y:-80)
                        Button {
                            
                        } label: {
                            Text("Delete program")
                        }
                        .padding(.bottom,20)
                        
                        Button {
                            
                        } label: {
                            Text("Edit program")
                        }
                    }
                    .presentationDetents([.large,.medium,.fraction(0.3)])
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background(
                        Rectangle()
                            .fill(.black)
                            .ignoresSafeArea(.container,edges: .all))
                    .presentationDragIndicator(.hidden)
                    
                }
                
                
            }
            
        }
        
    }
}

struct EditOrRemoveTheProgramm_Previews: PreviewProvider {
    static var previews: some View {
        EditOrRemoveTheProgram(program: .constant(GymModel.programs[0])).environmentObject(GymViewModel())
    }
}
