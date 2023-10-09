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
    @State var stringDate:String = ""
    var month:Date
    var body: some View
    {
        ZStack {
            if monthStruct().monthType == .Current {
                Text(monthStruct().day())
                    .foregroundColor(!isSelectedCheking() ? Color("backgroundDarkColor") : .white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .fontWeight(.bold)
                
                    .zIndex(1)
                
                Circle()
                    .frame(width: isSelectedCheking() ? viewModel.constW(w:40) : 0,height: isSelectedCheking() ? viewModel.constH(h:40) : 0)
                    .foregroundColor(Color("backgroundDarkColor"))
                    .zIndex(0)
                
                if hasProgram() {
                    Circle()
                        .frame(width: isSelectedCheking() ? 3 : 4,height: isSelectedCheking() ? 3 : 4)
                        .foregroundColor(Color("backgroundDarkColor"))
                        .offset(y: isSelectedCheking() ?  viewModel.constH(h:25) : viewModel.constH(h:15))
                        .zIndex(0)
                }
                
            }
            else {
                Color.white
            }
        }
    }
    
    
    
    func isSelectedCheking() -> Bool
    {
        
        let components = viewModel.selectedDate.get(.day, .month, .year)
        guard correctDay == Int(monthStruct().day()) else { return false}
        guard Calendar.current.isDate(viewModel.selectedDate, equalTo: month, toGranularity: .month) else { return false}
        
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
        var currentComponents = DateComponents()
        currentComponents.year = month.get(.year)
        currentComponents.month = month.get(.month)
        currentComponents.day = monthStruct().dayInt
        let date = Calendar.current.date(from: currentComponents)!
        let toStringDate = viewModel.toStringDate(date: date, history: false)
        return viewModel.trainings[toStringDate] != nil
    }
    
    
    func textColor(type: MonthType) -> Color
    {
        return type == MonthType.Current ? Color("backgroundDarkColor") : Color("MidGrayColor")
    }
    
    func monthStruct() -> MonthViewModel
    {
        CalendarModel().monthStruct(count: count, startingSpaces: startingSpaces, daysInPrevMonth: daysInPrevMonth, daysInMonth: daysInMonth)
    }
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Migrator()

        CalendarCellView(rowIndex: 1, count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1,correctDay: .constant(7), isSelected: .constant(Date()), month: Date()).environmentObject(GymViewModel())
    }
}
