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
    @State var isSelectedDay = false
    var body: some View
    {
        VStack(spacing: 1) {
            //            MonthLabelView(month:month)
            //                .environmentObject(viewModel)
            //                .padding()
            dayOfWeekStack
            calendarGrid
        }
    }
    
    var dayOfWeekStack: some View
    {
        HStack(spacing: 1)
        {
            Text("Sun").dayOfWeek()
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thu").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
        }
        .fontWeight(.bold)
        .foregroundColor(Color("RedColorScarlet"))
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
                    ForEach(1..<8)
                    {
                        column in
                        let count = column + (row * 7)
                        
                        CalendarCellView(count: count, startingSpaces:startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth,correctDay:$viewModel.selectedDayForChecking, isSelected: $isSelectedDay, month: month)
                            .environmentObject(viewModel)
                            .zIndex(1)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.2,dampingFraction: 0.4,blendDuration: 0.2)) {
                                    
                                    
                                    let monthStruct = CalendarModel().monthStruct(count: count, startingSpaces: startingSpaces, daysInPrevMonth: daysInPrevMonth, daysInMonth: daysInMonth)
                                    if monthStruct.monthType == .Current {
                                        correctDay = Int(monthStruct.day())!
                                        viewModel.selectDayForTraining(day: correctDay)
                                        isSelectedDay = true
                                        
                                    }
                                }
                            }
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
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

