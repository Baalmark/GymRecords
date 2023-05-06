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
    @State private var offset = CGSize.zero
    private var offsetCalendarViewY:CGFloat = 0
    private var systemColor = Color(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
    private var systemShadowColor = Color(UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1))
    @StateObject private var viewModel = GymViewModel()
    @State var minimizingCalendarOffSet:CGFloat = 0
    
    
    //Flags for changing calendar month
    
    private var previousMonth = false
    private var nextMonth = false
    
    var body: some View {
        ZStack{
            VStack{
                //Bar
                HStack {
                    MonthLabelView(month:viewModel.arrayOfMonths[1])
                        .environmentObject(viewModel)
                        .animation(.spring(), value: viewModel.arrayOfMonths[1])
                    
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
                                offset.width = value.translation.width
                            }
                            .onEnded { value in
                                let direction = viewModel.detectDirection(value: value)
                                if direction == .right, value.translation.width < -200 {
                                    viewModel.updateArrayMonthsNext()
                                    withAnimation() {
                                        offset.width = -405
                                    }
                                    offset.width = 0
                                } else if direction == .left, value.translation.width > 200{
                                    viewModel.updateArrayMonthsBack()
                                    withAnimation() {
                                        offset.width = 405
                                    }
                                    offset.width = 0
                                    
                                } else {
                                    withAnimation() {
                                        offset.width = 0
                                    }
                                }
                            })
                    }
                    .frame(width: viewModel.screenWidth * 3 + 30, height: 350)
                    .zIndex(0)
                    
                    
                    //Drag gesture line view
                ZStack(alignment:.top) {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: viewModel.screenWidth,height: 15)
                            .shadow(color: Color("LightGrayColor"), radius: 2,x:0,y:5)
                            .foregroundColor(.white)
                            .zIndex(2)
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 45,height: 4)
                            .foregroundColor(Color("LightGrayColor"))
                            .zIndex(2)
                        Image("backgroundMain")
                        .zIndex(1)
                        Rectangle().foregroundColor(.white)
                        .zIndex(0)
                    }
                    
                    .offset(x:0,y:minimizingCalendarOffSet)
                    .gesture(DragGesture()
                        .onChanged { value in
                            minimizingCalendarOffSet = value.translation.height
                            print(minimizingCalendarOffSet)
                        }
                        .onEnded { value in
                            minimizingCalendarOffSet = 0
                        })

                    .zIndex(0)
                    

                
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
        }
        .environmentObject(viewModel)
        .border(.blue)
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}


