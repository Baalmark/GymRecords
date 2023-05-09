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
    
    let rowIndex : Int
    let count : Int
    let startingSpaces : Int
    let daysInMonth : Int
    let daysInPrevMonth : Int
    @State var someFlag = false
    @Binding var correctDay: Int
    @State var tappedView = false
    @Binding var isSelected:Date
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
        
        
        
        guard correctDay == Int(monthStruct().day()) else { return false}
        guard Calendar.current.isDate(viewModel.selectedDate, equalTo: month, toGranularity: .month) else { return false}
        guard monthStruct().monthType == .Current else { return false}
        
        if let day = components.day {
            //let month = components.month, let year = components.year
            if day == monthStruct().dayInt {
                
                return true
            }
        }
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
        CalendarCellView(rowIndex: 1, count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1,correctDay: .constant(7), isSelected: .constant(Date()), month: Date()).environmentObject(GymViewModel())
    }
}
