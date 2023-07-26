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
            
            Circle()
                .frame(width: isSelectedCheking() ? 3 : 7,height: hasProgram() ? 3 : 7)
                .foregroundColor(.black)
                .offset(y: isSelectedCheking() ?  25 : 15)
                .opacity(hasProgram() ? 1 : 0)
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
    
    func hasProgram() -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for sDate in viewModel.trainings.keys {
//            print("SDATE - ",sDate)
            
            if let date = dateFormatter.date(from: sDate) {
                
                let components = date.get(.day,.month,.year)
                
                
                var currentComponents = DateComponents()
                currentComponents.year = month.get(.year)
                currentComponents.month = month.get(.month)
                currentComponents.day = monthStruct().dayInt
                 
//                print("Components",components)
//                print("Current Components", currentComponents)
                if components.day == currentComponents.day && components.month == currentComponents.month
                    && components.year == currentComponents.year{
                    return true
                }
                
            }
        }
        
       return false
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
