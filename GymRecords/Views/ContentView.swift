//
//  ContentView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 14.01.2023.
//

import SwiftUI
import RealmSwift
struct ContentView: View {
    
    @Environment(\.dismiss) var dismiss
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
    @State var collapsingViewFlag = true
    @State var scrollToIndex:Int = 0
    @State var mainButtonName = "Add exercises"
    @State var mainButtonEditName = "Edit program"
    var body: some View {
        VStack {
            ZStack{
                VStack{
                    //Bar
                    ZStack {
                        VStack {
                            HStack {
                                MonthLabelView(month:viewModel.arrayOfMonths[1])
                                //                                    .environmentObject(viewModel)
                                    .animation(.spring(), value: viewModel.arrayOfMonths[1])
                                
                                Spacer()
                                Button{
                                    viewModel.addExerciseFlag = false
                                    viewModel.editMode = false
                                    mainButtonEditName = "Edit program"
                                    mainButtonName = "Add exercises"
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
                            
                            dayOfWeekStack
                            
                        }
                        .background(.white)
                        .padding(.bottom,-10)
                        
                        Rectangle()
                            .frame(height: 80)
                            .zIndex(0)
                            .offset(y:-70)
                            .foregroundColor(.white)
                        
                    }
                    .zIndex(4)
                    HStack(spacing: 10) {
                        ForEach(viewModel.arrayOfMonths, id: \.self) { value in
                            CalendarView(month:value)
//                                .environmentObject(viewModel)
                            
                            
                        }
                        .background(.white)
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
                    .offset(x:0,y: minimizingCalendarOffSet / viewModel.getCoefficientOffset(row: viewModel.selectedDayRowHolder))
                    .zIndex(3)
                    .padding(.bottom, -10)
                    Spacer()
                }
            }
            .background(.white)
            .zIndex(2)
            .frame(height: collapsingViewFlag ? 140 : 415)
            .overlay(alignment:.center) {
                ZStack(alignment: .top){
                    //Drag gesture line view
                    dragGestureView
                        .zIndex(10)
                        .offset(x:0,y:minimizingCalendarOffSet)
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
                                            collapsingViewFlag = false
                                            
                                            
                                        }
                                    } else {
                                        withAnimation(.easeInOut) {
                                            minimizingCalendarOffSet = -295
                                            coeffOfTrainView = 295
                                            collapsingViewFlag = true
                                            
                                        }
                                    }
                                } else {
                                    if value.translation.height <= -125 {
                                        withAnimation(.easeInOut) {
                                            minimizingCalendarOffSet = -295
                                            coeffOfTrainView = 295
                                            collapsingViewFlag = true
                                            
                                        }
                                    }
                                }
                            })
                    
                    ScrollView {
                        if viewModel.isAnyTrainingSelectedDay(){
                            
                            VStack {
                                if viewModel.trainInSelectedDay.programTitle != "blank" && viewModel.trainInSelectedDay.programDescription != "blank" {
                                    ProgramItemListView(programm:$viewModel.trainInSelectedDay)
                                }
                                ForEachIndex(viewModel.trainInSelectedDay.exercises){ index,
                                    exercise in
                                    
                                    ContentViewExerciseFromTheListView(exercise: exercise).environmentObject(viewModel)
                                    
                                        .onTapGesture {
                                            
                                            viewModel.addSetsToExerciseSender(exercise:exercise)
                                            
                                        }
                                    if exercise.isSelectedToAddSet {
                                        AddSetsToExercise(exercise: exercise).environmentObject(viewModel)
                                            .onTapGesture {
                                                withAnimation(.easeInOut) {
                                                    scrollToIndex = index
                                                    viewModel.isShowedMainAddSetsView.toggle()
                                                }
                                            }
                                    }
                                }
                                .onChange(of: viewModel.trainInSelectedDay.exercises.count) { newValue in
                                    if newValue == 0 {
                                        viewModel.trainInSelectedDay = GymModel.Program(programTitle: "blank", programDescription: "blank", colorDesign: "red", exercises: [])
                                        viewModel.editMode = false
                                        viewModel.removeTrainingFromSelectedDay()
                                    }
                                }
                                
                                
                            }
                            
                            
                            .padding(.top,30)
                        } else {
                            Image("backgroundMain")
                                .offset(x:0,y: -minimizingCalendarOffSet / 2)
                                .padding()
                                .padding(.top,30)
                                .offset(y:collapsingViewFlag ? -140 : 0)
                            
                        }
                    }
                    
                    .frame(maxWidth: viewModel.screenWidth)
                    .frame(height: collapsingViewFlag ? 580 : 290)
                    .background(.white)
                    .offset(x:0,y:minimizingCalendarOffSet)
                }.zIndex(10)
                    .offset(y:collapsingViewFlag ? 510 : 360)
                
            }
            .offset(y:-130)
            HStack {
                Button(viewModel.isAnyTrainingSelectedDay() ? viewModel.editModeButtonName : mainButtonName) {
                    
                    if viewModel.isAnyTrainingSelectedDay() {
                        withAnimation(.easeInOut) {
                            viewModel.editMode.toggle()
                            viewModel.editModeButtonName = viewModel.editMode ? "Save" : "Edit program"
                        }
                    } else {
                        appearSheet.toggle()
                        viewModel.changeExercisesDB = false
                    }
                }
                .sheet(isPresented:$appearSheet) {
                    //viewModel.dataForProgramm
                    AddProgramView()
                }
                
                .buttonStyle(GrowingButton(isDarkMode: false,width: viewModel.editMode ? 335 / 2.2 : 335,height: 45))
                .tint(.white)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.trailing,10)
                .background(.white)
                .zIndex(3)
                .offset(y:collapsingViewFlag ? 290 : 155)
                .opacity(1)
                
                
                if viewModel.editMode {
                    Button("Add exercise") {
                        appearSheet.toggle()
                        viewModel.addExerciseFlag = true
                        viewModel.changeExercisesDB = false
                    }
                    .buttonStyle(GrowingButton(isDarkMode: false,width: 335 / 2.2,height: 45))
                    .tint(.black)
                    .font(.callout)
                    .fontWeight(.semibold)
                    
                    
                    .background(.clear)
                    .zIndex(3)
                    .offset(y:collapsingViewFlag ? 290 : 155)
                    .opacity(1)
                    
                    .sheet(isPresented:$appearSheet) {
                        //viewModel.dataForProgramm
                        
                        AddProgramView()
                    }
                }
            }
            .padding([.leading,.trailing],30)
            .padding(.top,10)
            
        }
        .frame(height: viewModel.screenHeight - 70)
        
        .overlay {
            if viewModel.isShowedMainAddSetsView {
                withAnimation(.easeOut) {
                    AddNewSetsMainView(scrollToIndex: scrollToIndex).environmentObject(viewModel)
                        .ignoresSafeArea(.keyboard)
                        .background(viewModel.blurOrBlackBackground ? .ultraThinMaterial : .ultraThick)
                        .transition(.move(edge: .bottom))
                        .onDisappear {
                            scrollToIndex = 0
                        }
                    
                }
            }
        }
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
                .shadow(color: Color("LightGrayColor"), radius: 3,x:0,y:6)
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
       
        let migrator = Migrator()
        ContentView().environmentObject(GymViewModel())
        
    }
}


