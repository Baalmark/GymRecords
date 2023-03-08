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
    @State private var offset = CGSize.zero
    private var offsetCalendarViewY:CGFloat = 0
    private var systemColor = Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
    private var systemShadowColor = Color(UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1))
    @StateObject private var viewModel = GymViewModel()
    
    
    
    //Flags for changing calendar month
    
    private var previousMonth = false
    private var nextMonth = false
    
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
            
            HStack(spacing: 10) {
                ForEach(viewModel.arrayOfMonths, id: \.self) { value in
                    CalendarView(month:value).environmentObject(viewModel)
                }
                .offset(x: offset.width, y:0)
                    .gesture(DragGesture()
                        .onChanged { value in
                            offset = value.translation
                            
                        }
                        .onEnded { value in
                            
                            let direction = viewModel.detectDirection(value: value)
                            if direction == .right, value.translation.width < -200 {
                                print("Left ended  \(viewModel.arrayOfMonths)")
                                withAnimation(.easeInOut) {
                                    
                                    viewModel.updateArrayMonthsNext()
                                    offset.width = 0
                                }
                            } else if direction == .left, value.translation.width > 200{
                                print("Right ended \(viewModel.arrayOfMonths)")
                                withAnimation(.easeInOut) {
                                    
                                    viewModel.updateArrayMonthsBack()
                                    offset.width = 0
                                                                    }
                            } else {
                                withAnimation(.easeInOut) {
                                    offset.width = 0
                                }
                            }
                            
                        })
            }
            .frame(width: viewModel.screenWidth * 3 + 30, height: 500)
                
            
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


