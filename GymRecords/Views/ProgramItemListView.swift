//
//  ProgrammItemListView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 10.02.2023.
//

import SwiftUI

struct ProgramItemListView: View {
    @EnvironmentObject var viewModel:GymViewModel
    @Binding var programm:GymModel.Program
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment:.leading) {
                    Text("\(programm.programTitle)")
                    Text("\(programm.programDescription)")
                        .font(.custom("Helvetica", size: viewModel.constW(w:18)))
                        .fontWeight(.bold)
                }
                .padding(.leading,20)
                .font(.custom("Helvetica", size: viewModel.constW(w:20)))
                .fontWeight(.bold)
                .padding(.leading,10)
                Spacer()
                Text("\(programm.exercises.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .background(Circle()
                        .frame(width: viewModel.constW(w:50),height: viewModel.constW(w:50))
                        .foregroundStyle(Color[programm.colorDesign].gradient)
                        .overlay(Circle().opacity(0.1))
                                
                    )
                
                    .padding(.trailing,30)
                
            }
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 10)
                .frame(width: viewModel.constW(w:viewModel.screenWidth - 20),height: viewModel.constH(h:60))
                        
                .foregroundStyle(Color[programm.colorDesign].gradient))
            
            .padding(10)
            if viewModel.editMode {
                withAnimation {
                    ZStack {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("GrayColor"))
                            .tint(.black)
                            .font(.callout)
                            .zIndex(1)
                        Circle().frame(width: viewModel.constW(w:15),height: viewModel.constW(w:15))
                            .foregroundColor(.white)
                            .zIndex(0)
                    }
                    .offset(x:viewModel.constW(w:185),y:viewModel.constH(h:-72.5))
                    .background(Circle()
                        .frame(width: viewModel.constW(w:30),height: viewModel.constW(w:30)))
                    .foregroundColor(.clear)
                    
                    .onTapGesture {
                        withAnimation(.easeInOut(duration:0.1)) {
                            viewModel.removeTrainingByClick(selectedDate: viewModel.selectedDate)
                        }
                    }
                }
            }
        }
    }
}

struct ProgrammItemListView_Previews: PreviewProvider {
    static var previews: some View {
        let migrator = Migrator()
        ProgramItemListView(programm: .constant(GymModel().programs[0])).environmentObject(GymViewModel())
    }
}
