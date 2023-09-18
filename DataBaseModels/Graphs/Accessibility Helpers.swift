//
//  Accessibility Helpers.swift
//  GymRecords
//
//  Created by Pavel Goldman on 18.09.2023.
//

import SwiftUI

/*
 This file collects functions used by
 the Accessibility descriptors of charts for data that is re-used across chart types.
 
 The detailed versions simply use accessibilityLabel/accessibilityValue for each Mark.

 NOTE: Filed FB10320202 indicating some Mark types do not use label/value set on the Mark
 */

extension TimeInterval {
    var accessibilityDurationFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .brief
        formatter.maximumUnitCount = 1
        
        return formatter
    }
    
    var durationDescription: String {
        let hqualifier = (hours == 1) ? "hour" : "hours"
        let mqualifier = (minutes == 1) ? "minute" : "minutes"
        
        return accessibilityDurationFormatter.string(from: self) ??
        String(format:"%d \(hqualifier) %02d \(mqualifier)", hours, minutes)
    }

    var hours: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    
    var minutes: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
}

extension Date {
    // Used for charts where the day of the week is used: visually  M/T/W etc
    // (but we want VoiceOver to read out the full day)
    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"

        return formatter.string(from: self)
    }
}

enum AccessibilityHelpers {
    // TODO: This should be a protocol but since the data objects are in flux this will suffice
    static func chartDescriptorReps(forCountSeries data: [RepsData],
                                repsThreshold: Double? = nil,
                                isContinuous: Bool = false) -> AXChartDescriptor {

        // Since we're measuring a tangible quantity,
        // keeping an independant minimum prevents visual scaling in the Rotor Chart Details View
        let min = 0 // data.map(\.reps).min() ??
        let max = data.map(\.reps).max() ?? 0

        // A closure that takes a date and converts it to a label for axes
        let dateTupleStringConverter: ((RepsData) -> (String)) = { dataPoint in

            let dateDescription = dataPoint.day.formatted(date: .complete, time: .omitted)

            if let threshold = repsThreshold {
                let isAbove = dataPoint.isAbove(threshold: threshold)

                return "\(dateDescription): \(isAbove ? "Above" : "Below") threshold"
            }

            return dateDescription
        }

        let xAxis = AXNumericDataAxisDescriptor(
            title: "Date index",
            range: Double(0)...Double(data.count),
            gridlinePositions: []
        ) { "Day \(Int($0) + 1)" }

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Reps",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) done" }

        let series = AXDataSeriesDescriptor(
            name: "Daily reps quantity",
            isContinuous: isContinuous,
            dataPoints: data.enumerated().map { (idx, point) in
                    .init(x: Double(idx),
                          y: Double(point.reps),
                          label: dateTupleStringConverter(point))
            }
        )

        return AXChartDescriptor(
            title: "Reps per day",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
    
    
    // TODO: This should be a protocol but since the data objects are in flux this will suffice
    static func chartDescriptorWeight(forCountSeries data: [WeightData],
                                weightThreshold: Double? = nil,
                                isContinuous: Bool = false) -> AXChartDescriptor {

        // Since we're measuring a tangible quantity,
        // keeping an independant minimum prevents visual scaling in the Rotor Chart Details View
        let min = 0 // data.map(\.weight).min() ??
        let max = data.map(\.weight).max() ?? 0

        // A closure that takes a date and converts it to a label for axes
        let dateTupleStringConverter: ((WeightData) -> (String)) = { dataPoint in

            let dateDescription = dataPoint.day.formatted(date: .complete, time: .omitted)

            if let threshold = weightThreshold {
                let isAbove = dataPoint.isAbove(threshold: threshold)

                return "\(dateDescription): \(isAbove ? "Above" : "Below") threshold"
            }

            return dateDescription
        }

        let xAxis = AXNumericDataAxisDescriptor(
            title: "Date index",
            range: Double(0)...Double(data.count),
            gridlinePositions: []
        ) { "Day \(Int($0) + 1)" }

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Weight",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) lifted" }

        let series = AXDataSeriesDescriptor(
            name: "Daily weight quantity",
            isContinuous: isContinuous,
            dataPoints: data.enumerated().map { (idx, point) in
                    .init(x: Double(idx),
                          y: Double(point.weight),
                          label: dateTupleStringConverter(point))
            }
        )

        return AXChartDescriptor(
            title: "Weight lifted",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }

}
