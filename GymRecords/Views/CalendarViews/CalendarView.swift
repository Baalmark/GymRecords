//
//  CalendarView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 07.03.2023.
//

import SwiftUI

struct CalendarView: View
{
    @EnvironmentObject var dateHolder: DateHolderModel
    
    var body: some View
    {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                test
            }
            
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
    }
    
    var calendarGrid: some View
    {
        VStack(spacing: 1)
        {
            let daysInMonth = CalendarModel().daysInMonth(dateHolder.date)
            let firstDayOfMonth = CalendarModel().firstOfMonth(dateHolder.date)
            let startingSpaces = CalendarModel().weekDay(firstDayOfMonth)
            let prevMonth = CalendarModel().minusMonth(dateHolder.date)
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
                        CalendarCellView(count: count, startingSpaces:startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth)
                            .environmentObject(dateHolder)
                        
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    var test: some View {
        TabView {
            ForEach(dateHolder.arrayOfMonths, id: \.self) { value in
                VStack(spacing: 1)
                {
                    
                    MonthLabelView(month: value)
                        .environmentObject(dateHolder)
                        .padding()
                    dayOfWeekStack
                    calendarGrid
                    
                }
                
            }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    func previousMonth()
    {
        dateHolder.date = CalendarModel().minusMonth(dateHolder.date)
    }
    
    func nextMonth()
    {
        dateHolder.date = CalendarModel().plusMonth(dateHolder.date)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView().environmentObject(DateHolderModel())
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

