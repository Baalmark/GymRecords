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
        ZStack(alignment:.topTrailing) {
            VStack {
                HStack {
                    VStack(alignment:.leading) {
                        Text("\(programm.programTitle)")
                        Text("\(programm.programDescription)")
                            .font(.custom("Helvetica", size: 18))
                            .fontWeight(.bold)
                    }
                    .padding(.leading,20)
                    .font(.custom("Helvetica", size: 20))
                    .fontWeight(.bold)
                    .padding(.leading,10)
                    Spacer()
                    Text("\(programm.exercises.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .background(Circle()
                            .frame(width: 50,height: 50)
                            .foregroundStyle(Color[programm.colorDesign].gradient)
                            .overlay(Circle().opacity(0.1))
                                    
                        )
                    
                        .padding(.trailing,30)
                    
                }
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 10)
                    .frame(width: viewModel.screenWidth - 20,height: 60)
                            
                    .foregroundStyle(Color[programm.colorDesign].gradient))
                
                .padding(10)
            }
               if viewModel.editMode {
                    withAnimation {
                        ZStack {
                            Image(systemName: "xmark.circle.fill")
                                .tint(.black)
                                
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom))
                                .font(.callout)
                                .zIndex(1)
                            Circle().frame(width: 15,height: 15)
                                .foregroundColor(.clear)
                                .zIndex(0)
                        }
                        
                        .background(Circle()
                            .frame(width: 30,height: 30))
                        .foregroundColor(.clear)
                        .padding(.top,-5)
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
