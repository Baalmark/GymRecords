//
//  ContentView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 14.01.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var appearSheet = false
    @State var isDataBaseSheetActive = false
    @State var selectedDate: Date = Date()
    
    private var offsetCalendarViewY:CGFloat = 0
    private var systemColor = Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
    private var systemShadowColor = Color(UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1))
    @StateObject private var viewModel = GymViewModel()
    
    
    var body: some View {
        
        VStack{
            //Bar
                HStack {
                    Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(Color.black)
                        .animation(.spring(), value: selectedDate)
                    
                    Spacer()
                    Button{
                        viewModel.changeExercisesDB = true
                        isDataBaseSheetActive.toggle()
                    } label: {
                        Image("weight")
                            .fixedSize()
                    }
                    .sheet(isPresented: $isDataBaseSheetActive) {
                        DataBaseView()
                    }
                }.zIndex(1)
            
            .padding([.leading,.trailing], 10)
            
            CalendarView().environmentObject(DateHolderModel())
            
            Spacer()
                Button("Add Programm") {
                    appearSheet.toggle()
                    viewModel.changeExercisesDB = false
                }
                .sheet(isPresented:$appearSheet) {
                    //viewModel.dataForProgramm
                    AddProgramView()
                }
                .buttonStyle(GrowingButton(isDarkMode: false,width: 335,height: 45))
                .tint(.white)
                .font(.title2)
                .fontWeight(.semibold)
                
            }
        .environmentObject(viewModel)
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}


