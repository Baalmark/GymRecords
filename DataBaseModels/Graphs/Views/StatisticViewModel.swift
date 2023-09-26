//
//  StatisticViewModel.swift
//  GymRecords
//
//  Created by Pavel Goldman on 19.09.2023.
//

import SwiftUI
import Charts
class StatisticViewModel:ObservableObject {
    private var lineWidth = 1.0
    private var interpolationMethod: ChartInterpolationMethod = .monotone
    private var chartColor: Color = .black
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.4),         Color.black.opacity(0)]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    @Published var data:([RepsData],[WeightData]) = allData.overViewExample7
    
    
    //MARK: Get last period of days statistic
    // -> [(Date,Sets)]
    func getlastPeriod(exercise:Exercise,period:Int) -> ([RepsData],[WeightData]) {
        var result:([RepsData],[WeightData]) = ([],[])
        // Iterate by 1 day
        let dayDurationInSeconds: TimeInterval = 60*60*24
        let now:Date = Date().addingTimeInterval(dayDurationInSeconds)
        let startPoint = now.addingTimeInterval(-(Double(period) * 24.0 * 3600))
        
        
        for date in stride(from: startPoint, to: now, by: dayDurationInSeconds) {
            let dataOfSets = summaryOfSetsInOneDay(date: date, allSets: exercise.sets)
            if dataOfSets.0 != 0 && dataOfSets.1 != 0 {
                let newObjectReps = RepsData(day: date, reps: dataOfSets.0)
                let newObjectWeights = WeightData(day: date, weight: dataOfSets.1)
                result.0.append(newObjectReps)
                result.1.append(newObjectWeights)
            }
            
        }
        refreshData(data: result)
        return result
    }
    
    func summaryOfSetsInOneDay(date:Date,allSets:[Sets]) -> (Double,Double) {
        
        let filteredSets = allSets.filter {
            $0.date.hasSame(.day, as: date) && $0.date.hasSame(.month, as: date) && $0.date.hasSame(.year, as: date)
        }
        var reps:Double = 0
        var weights:Double = 0
        for nSet in filteredSets {
            reps += nSet.reps
            weights += nSet.weight
        }
        return (reps,weights)
    }
    
    func compareSelectedMarkerToChartMarker<T: Equatable>(selectedMarker: T, chartMarker: T) -> Bool {
        return selectedMarker == chartMarker
    }
    
    
    func refreshData(data:([RepsData],[WeightData])) {
        self.data = data
    }
    
    func getBaselineMarkerReps(marker: RepsData) -> some ChartContent {
        return LineMark(
            x: .value("Date", marker.day),
            y: .value("Reps", marker.reps)
        )
        .accessibilityLabel(marker.day.formatted(date: .complete, time: .omitted))
        .accessibilityValue("\(marker.reps) done")
        .lineStyle(StrokeStyle(lineWidth: lineWidth))
        .foregroundStyle(chartColor)
        .interpolationMethod(interpolationMethod.mode)
        .symbolSize(5)
    }
    func getBaselineMarkerWeight(marker: WeightData) -> some ChartContent {
        return LineMark(
            x: .value("Date", marker.day),
            y: .value("Weight", marker.weight)
        )
        .accessibilityLabel(marker.day.formatted(date: .complete, time: .omitted))
        .accessibilityValue("\(marker.weight) done")
        .lineStyle(StrokeStyle(lineWidth: lineWidth))
        .foregroundStyle(chartColor)
        .interpolationMethod(interpolationMethod.mode)
        .symbolSize(5)
    }
    func getBaselineMarkerRepsBack(marker: RepsData) -> some ChartContent {
        return AreaMark(
            x: .value("Date", marker.day),
            y: .value("Reps", marker.reps)
        )
        .accessibilityLabel(marker.day.formatted(date: .complete, time: .omitted))
        .accessibilityValue("\(marker.reps) done")
        .lineStyle(StrokeStyle(lineWidth: lineWidth))
        .foregroundStyle(linearGradient)
        .interpolationMethod(interpolationMethod.mode)
    }
    func getBaselineMarkerWeightBack(marker: WeightData) -> some ChartContent {
        return AreaMark(
            x: .value("Date", marker.day),
            y: .value("Weight", marker.weight)
        )
        .accessibilityLabel(marker.day.formatted(date: .complete, time: .omitted))
        .accessibilityValue("\(marker.weight) done")
        .lineStyle(StrokeStyle(lineWidth: lineWidth))
        .foregroundStyle(linearGradient)
        .interpolationMethod(interpolationMethod.mode)
    }
    
    func findElementReps(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> RepsData? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for countDataIndex in data.0.indices {
                let nthSalesDataDistance = data.0[countDataIndex].day.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = countDataIndex
                }
            }
            if let index {
                return data.0[index]
            }
            
            
        }
        return nil
    }
    
    func findElementWeight(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> WeightData? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for countDataIndex in data.1.indices {
                let nthSalesDataDistance = data.1[countDataIndex].day.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = countDataIndex
                }
            }
            if let index {
                return data.1[index]
            }
        }
        return nil
    }
    
    //MARK: Max rep getter
    func getMaxRep(reps:[RepsData]) -> Double {
        var temp:Double = 0
        for rep in reps {
            if temp < rep.reps {
                temp = rep.reps
            }
        }
        
        return temp.rounded(.awayFromZero)
    }
    //MARK: Max weight getter
    func getMaxWeight(weights:[WeightData]) -> Double {
        var temp:Double = 0
        for weight in weights {
            if temp < weight.weight {
                temp = weight.weight
            }
        }
        
        return temp.rounded(.awayFromZero)
    }
    
    //    func returnHistoryForStatisticView(data:([RepsData],[WeightData])) -> [String:[]]
    
    func returnAllMonthFromData(data:([RepsData],[WeightData])){
        
       
    }
    
    
}


enum Month : String{
    case January = "January"
    case February = "February"
    case March = "March"
    case April = "April"
    case May = "May"
    case June = "June"
    case July = "July"
    case August = "August"
    case September = "September"
    case October = "October"
    case November = "November"
    case December = "December"
    
    
    func stringMonth() -> String {
        self.rawValue
    }
}
