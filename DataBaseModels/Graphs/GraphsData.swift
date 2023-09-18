//
//  GraphsData.swift
//  GymRecords
//
//  Created by Pavel Goldman on 18.09.2023.
//

import Foundation

func date(year: Int, month: Int, day: Int = 1, hour: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minutes, second: seconds)) ?? Date()
}


/// Data for the daily and monthly count  charts.
enum allData {
    static var OverViewExampleTotalReps: Double {
        overViewExample7.0.map { $0.reps }.reduce(0, +)
    }
    static var OverViewExampleTotalWeight: Double {
        overViewExample7.1.map { $0.weight }.reduce(0, +)
    }

    /// Sales by month for the last 12 months.
    static let overViewExample7: ([RepsData],[WeightData]) = (
        [RepsData(day: date(year:2023,month:5,day:1), reps: 50),
         RepsData(day: date(year:2023,month:5,day:5), reps: 60),
         RepsData(day: date(year:2023,month:5,day:10), reps: 70),
         RepsData(day: date(year:2023,month:5,day:15), reps: 80),
         RepsData(day: date(year:2023,month:5,day:20), reps: 70),
         RepsData(day: date(year:2023,month:5,day:25), reps: 90)
        ,RepsData(day: date(year:2023,month:5,day:30), reps: 100)],
        [WeightData(day: date(year: 2023, month: 5, day: 1), weight: 150),
         WeightData(day: date(year: 2023, month: 5, day: 5), weight: 160),
         WeightData(day: date(year: 2023, month: 5, day: 10), weight: 170),
         WeightData(day: date(year: 2023, month: 5, day: 15), weight: 160),
         WeightData(day: date(year: 2023, month: 5, day: 20), weight: 180),
         WeightData(day: date(year: 2023, month: 5, day: 25), weight: 290),
         WeightData(day: date(year: 2023, month: 5, day: 30), weight: 400)]
    )
}

struct RepsData: Equatable {
    let day: Date
    var reps: Double
}
struct WeightData: Equatable {
    let day: Date
    var weight: Double
}


extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: .now)
    }
}

extension Date {
    func nearestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute, .second, .nanosecond], from: self)
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        let nanosecond = components.nanosecond ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        components.second = -second
        components.nanosecond = -nanosecond
        return Calendar.current.date(byAdding: components, to: self)
    }
}

extension Array {
    func appending(contentsOf: [Element]) -> Array {
        var a = Array(self)
        a.append(contentsOf: contentsOf)
        return a
    }
}

extension RepsData {
    func isAbove(threshold: Double) -> Bool {
        self.reps > Double(threshold)
    }
}
extension WeightData {
    func isAbove(threshold: Double) -> Bool {
        self.weight > Double(threshold)
    }
}
