//
//  MonthLabelView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 07.03.2023.
//

import SwiftUI

struct MonthLabelView: View
{
    @EnvironmentObject var viewModel:GymViewModel
    
    var month:Date
    var body: some View
    {
        HStack
        {
            Spacer()
            Button {
                
                previousMonth()
            } label:
            {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
                    .opacity(0)
            }
            Text(CalendarModel().monthYearString(month))
                .font(.title)
                .bold()
                .animation(.none)
                .frame(maxWidth: .infinity)
            Button {
                
                nextMonth()
            } label:
            {
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
                    .opacity(0)
            }
            Spacer()
        }
    }
    
    func previousMonth()
    {
        viewModel.date = CalendarModel().minusMonth(viewModel.date)
    }
    
    func nextMonth()
    {
        viewModel.date = CalendarModel().plusMonth(viewModel.date)
    }
}

struct MonthLabelView_Previews: PreviewProvider {
    static var previews: some View {
        MonthLabelView(month:GymViewModel().date).environmentObject(GymViewModel())
    }
}
