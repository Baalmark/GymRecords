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
    @State var minimizingCalendarOffSet:CGFloat = -295
    //Flags for changing calendar month
    @State private var coeffOfTrainView:CGFloat = 0
    private var previousMonth = false
    private var nextMonth = false
    
    var body: some View {
        ZStack{
            VStack{
                //Bar
                VStack {
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
                    }
                    
                    
                    .padding([.leading,.trailing], 10)
                    .background(.white)
                    dayOfWeekStack
                        .background(.white)
                }
                .background(.white)
                .offset(y:220) // test offset
                .padding(.bottom,-10)
                
                .zIndex(4)
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
                .offset(x:0,y: minimizingCalendarOffSet / viewModel.getCoefficientOffset(row: viewModel.selectedDayRowHolder) + 215) // test offset
                .zIndex(3)
                .padding(.bottom, -10)
                
                //Drag gesture line view
               
                    dragGestureView
                        .zIndex(10)
                        .offset(x:0,y:minimizingCalendarOffSet + 65)
                        .gesture(DragGesture()
                            .onChanged { value in
                                if value.translation.height <= 0{
                                    if minimizingCalendarOffSet > -295 {
                                        minimizingCalendarOffSet = value.translation.height
                                    }
                                } else {
                                    if minimizingCalendarOffSet < 0 {
                                        minimizingCalendarOffSet = -295 + value.translation.height
                                    }
                                }
                                
                                
                            }
                            .onEnded { value in
                                if minimizingCalendarOffSet < 0 {
                                    if value.translation.height >= 125 {
                                        withAnimation(.easeInOut) {
                                            minimizingCalendarOffSet = 0
                                            coeffOfTrainView = 0
                                        }
                                    } else {
                                        withAnimation(.easeInOut) {
                                            minimizingCalendarOffSet = -295
                                            coeffOfTrainView = 295
                                        }
                                    }
                                } else {
                                    if value.translation.height <= -125 {
                                        withAnimation(.easeInOut) {
                                            minimizingCalendarOffSet = -295
                                            coeffOfTrainView = 295
                                        }
                                    }
                                }
                            })
                    
                    ScrollView {
                            if viewModel.isAnyTrainingSelectedDay() {
                                VStack {
                                    ForEach(viewModel.trainings[viewModel.toStringDate(date: viewModel.selectedDate)]!.exercises, id: \.id) {
                                        exercise in
                                        HStack {
                                            Image(exercise.type.rawValue)
                                            Text(exercise.name.capitalized)
                                            Spacer()
                                            Image(systemName: "chevron.up")
                                            
                                        }
                                        .padding([.leading,.trailing],10)
                                    }
                                }.padding()
                                    .padding(.top,30)
                                    .background(.white)
                                    .zIndex(4)
                            } else {
                                Image("backgroundMain")
                                    .zIndex(5)
                                    .offset(x:0,y: -minimizingCalendarOffSet / 2.5)
                                    .padding()
                                    .padding(.top,30)
                            }
                            
                            
                        
                    }
                        .frame(width: viewModel.screenWidth,height: 400,alignment: .bottom)
                        .zIndex(2)
                            .offset(y:minimizingCalendarOffSet + 100)
                    
                    
                
                
                .frame(width: viewModel.screenWidth,height: 700 )
                .border(.green)
                
                .background(.white)
                
                
                .zIndex(2)
                
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
                .padding([.leading,.trailing,.top],30)
                .background(.white)
                .offset(y:-220)
                .zIndex(4)
                
                Spacer()
            }
        }
        .background(.white)
        .zIndex(2)
        .environmentObject(viewModel)
        
    }
    
    var dayOfWeekStack: some View
    {
        HStack(spacing: 1)
        {
            
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thu").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
            Text("Sun").dayOfWeek()
        }
        .fontWeight(.bold)
        .foregroundColor(Color("MidGrayColor"))
    }
    
    var dragGestureView: some View
    {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: viewModel.screenWidth,height: 15)
                .shadow(color: .gray, radius: 3,x:0,y:6)
                .foregroundColor(.white)
                .zIndex(2)
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 45,height: 4)
                .foregroundColor(Color("LightGrayColor"))
                .zIndex(2)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}


