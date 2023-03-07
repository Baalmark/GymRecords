//
//  MonthLabelView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 07.03.2023.
//

import SwiftUI

struct MonthLabelView: View
{
    @EnvironmentObject var dateHolder: DateHolderModel
    var month:Date
    
    var body: some View
    {
        HStack
        {
            Spacer()
            Button {
                dateHolder.date = month
                previousMonth()
            } label:
            {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
            }
            Text(CalendarModel().monthYearString(month))
                .font(.title)
                .bold()
                .animation(.none)
                .frame(maxWidth: .infinity)
            Button {
                dateHolder.date = month
                nextMonth()
            } label:
            {
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
            }
            Spacer()
        }
    }
    
    func previousMonth()
    {
        dateHolder.date = CalendarModel().minusMonth(dateHolder.date)
        print(dateHolder.date)
    }
    
    func nextMonth()
    {
        dateHolder.date = CalendarModel().plusMonth(dateHolder.date)
    }
}

struct MonthLabelView_Previews: PreviewProvider {
    static var previews: some View {
        MonthLabelView(month: DateHolderModel().date).environmentObject(DateHolderModel())
    }
}
