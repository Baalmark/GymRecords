//
//  MonthViewModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 07.03.2023.
//

import Foundation
import SwiftUI


struct MonthViewModel
{
    var monthType: MonthType
    var dayInt : Int
    func day() -> String
    {
        return String(dayInt)
    }
}

enum MonthType
{
    case Previous
    case Current
    case Next
}
