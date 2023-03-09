//
//  CalendarCellView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 07.03.2023.
//

import SwiftUI

struct CalendarCellView: View
{
    @EnvironmentObject var viewModel:GymViewModel

    
    let count : Int
    let startingSpaces : Int
    let daysInMonth : Int
    let daysInPrevMonth : Int
    @State var correctDay: Int = 1
    @State var tappedView = false
    var body: some View
    {
        ZStack {
            
            Text(monthStruct().day())
                .foregroundColor(!tappedView ? textColor(type: monthStruct().monthType) : .white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .fontWeight(.bold)
                .zIndex(1)
                .onTapGesture {
                    withAnimation(.spring(response: 0.2,dampingFraction: 0.4,blendDuration: 0.2)) {
                        tappedView.toggle()
                        
                        if let day = Int(monthStruct().day()) {
                            correctDay = day
                            viewModel.selectDayForTraining(day: day)
                        }
                    }
                }
                Circle()
                .frame(width: tappedView ? 40 : 0,height: tappedView ? 40 : 0)
                    .foregroundColor(.black)
                    .zIndex(0)
            
        }
    }
    func textColor(type: MonthType) -> Color
    {
        return type == MonthType.Current ? Color.black : Color("MidGrayColor")
    }
    
    func monthStruct() -> MonthViewModel
    {
        let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
        if(count <= start)
        {
            let day = daysInPrevMonth + count - start
            return MonthViewModel(monthType: MonthType.Previous, dayInt: day)
        }
        else if (count - start > daysInMonth)
        {
            let day = count - start - daysInMonth
            return MonthViewModel(monthType: MonthType.Next, dayInt: day)
        }
        
        let day = count - start
        return MonthViewModel(monthType: MonthType.Current, dayInt: day)
    }
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCellView(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1)
    }
}
