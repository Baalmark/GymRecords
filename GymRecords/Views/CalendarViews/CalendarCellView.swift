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
    @Binding var correctDay: Int
    @State var tappedView = false
    @Binding var isSelected:Bool
    var month:Date
    var body: some View
    {
        ZStack {
            Text(monthStruct().day())
                .foregroundColor(!isSelectedCheking() ? .black : .white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .fontWeight(.bold)
                .opacity(monthStruct().monthType == .Current ? 1 : 0)
                .zIndex(1)
            
                Circle()
                .frame(width: isSelectedCheking() ? 40 : 0,height: isSelectedCheking() ? 40 : 0)
                    .foregroundColor(.black)
                    .zIndex(0)
            }
    }
    

    
    func isSelectedCheking() -> Bool
    {
        let components = viewModel.selectedDate.get(.day, .month, .year)
        
        if let day = components.day, let month = components.month, let year = components.year {
            if day == monthStruct().dayInt{
                return true
            }
        }
        
        guard isSelected else { return false }
        guard correctDay == Int(monthStruct().day()) else { return false}
        let selectedDate = viewModel.selectedDate
        guard Calendar.current.isDate(selectedDate, equalTo: month, toGranularity: .month) else { return false}
        guard monthStruct().monthType == .Current else { return false}
        return true
    }

    
func textColor(type: MonthType) -> Color
{
    return type == MonthType.Current ? Color.black : Color("MidGrayColor")
}

func monthStruct() -> MonthViewModel
{
    CalendarModel().monthStruct(count: count, startingSpaces: startingSpaces, daysInPrevMonth: daysInPrevMonth, daysInMonth: daysInMonth)
}
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCellView(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1,correctDay: .constant(7), isSelected: .constant(true), month: Date())
    }
}
