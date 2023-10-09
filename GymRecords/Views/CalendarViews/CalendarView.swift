//
//  CalendarView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 07.03.2023.
//

import SwiftUI

struct CalendarView: View
{
    @EnvironmentObject var viewModel:GymViewModel
    
    var month:Date
    @State var tappedView = false
    @State var correctDay = 0
    @State var isSelectedDay:Date = Date()
    var body: some View
    {
        VStack(spacing: 1) {
            calendarGrid
        }
    }
    
    
    
    var calendarGrid: some View
    {
        VStack(spacing: 1)
        {
            let daysInMonth = CalendarModel().daysInMonth(month)
            let firstDayOfMonth = CalendarModel().firstOfMonth(month)
            let startingSpaces = CalendarModel().weekDay(firstDayOfMonth)
            let prevMonth = CalendarModel().minusMonth(month)
            let daysInPrevMonth = CalendarModel().daysInMonth(prevMonth)
            
            ForEach(0..<6)
            {
                row in
                
                HStack(spacing: 1)
                {
                    ForEach(2..<9)
                    {
                        column in
                        let count = column + (row * 7)
                        let rowIndex = row
                        CalendarCellView(rowIndex: rowIndex, count: count, startingSpaces:startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth,correctDay:$viewModel.selectedDayForChecking, isSelected: $isSelectedDay, month: month)
                       
                            .onAppear {
                                let monthStruct = CalendarModel().monthStruct(count: count, startingSpaces: startingSpaces, daysInPrevMonth: daysInPrevMonth, daysInMonth: daysInMonth)
                                if monthStruct.monthType == .Current {
                                    correctDay = Int(monthStruct.day())!
                                    if viewModel.checkTheRowForTheSelectedDay(correctDay: correctDay, month: month) {
                                        viewModel.selectedDayRowHolder = row
                                        viewModel.selectingTheDayWithTraining()
                                  
                                    }
                                    
                                }
                            }
                            .zIndex(1)
                            .onTapGesture {
                                HapticManager.instance.impact(style: .soft)
                                withAnimation(.spring(response: 0.2,dampingFraction: 0.4,blendDuration: 0.2)) {
                                    
                                    viewModel.editMode = false
                                    viewModel.editModeButtonName = "Edit program"
                                    viewModel.addExerciseFlag = false
                                    let monthStruct = CalendarModel().monthStruct(count: count, startingSpaces: startingSpaces, daysInPrevMonth: daysInPrevMonth, daysInMonth: daysInMonth)
                                    if monthStruct.monthType == .Current {
                                        correctDay = Int(monthStruct.day())!
                                        viewModel.selectDayForTraining(day: correctDay)
                                        
                                        
                                        viewModel.selectedDayRowHolder = row
                                        viewModel.selectingTheDayWithTraining()
                                        
                                    }
                                    
                                }
                            }
                            .disabled(viewModel.disabledDragGestureCalendarView)
                            
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()

        CalendarView(month: GymViewModel().date).environmentObject(GymViewModel())
    }
}


extension Text
{
    func dayOfWeek() -> some View
    {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}

