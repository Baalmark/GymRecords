//
//  ChartType.swift
//  GymRecords
//
//  Created by Pavel Goldman on 18.09.2023.
//

import SwiftUI

enum ChartCategory: String, CaseIterable, Hashable, Identifiable {
    case all
    case apple
    case line
    case bar
    case area
    case range
    case heatMap
    case point

    var id: String { self.rawValue }

    var sfSymbolName: String {
        switch self {
        case .all:
            return ""
        case .apple:
            return "applelogo"
        case .line:
            return "chart.xyaxis.line"
        case .bar:
            return "chart.bar.fill"
        case .area:
            return "triangle.fill"
        case .range:
            return "trapezoid.and.line.horizontal.fill"
        case .heatMap:
            return "checkerboard.rectangle"
        case .point:
            return "point.3.connected.trianglepath.dotted"
        }
    }
}

enum ChartType: String, Identifiable, CaseIterable {
    // Apple
    case heartBeat
    case oneDimensionalBar
    case screenTime

    // Line Charts
    case singleLine
    case singleLineLollipop
    case animatingLine
    case gradientLine
    case multiLine
    case linePoint

    // Bar Charts
    case singleBar
    case singleBarThreshold
    case twoBars
    case pyramid
    case timeSheetBar
    #if canImport(UIKit)
    case soundBar
    #endif
    case scrollingBar

    // Area Charts
    case areaSimple
    case stackedArea

    // Range Charts
    case rangeSimple
    case rangeHeartRate
    case candleStick

    // HeatMap Charts
    case customizeableHeatMap
    case gitContributions

    // Point Charts
    case scatter
    case vectorField

    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .heartBeat:
            return "Electrocardiograms (ECG)"
        case .oneDimensionalBar:
            return "iPhone Storage"
        case .screenTime:
            return "Screen Time"
        case .singleLine:
            return "Line Chart"
        case .singleLineLollipop:
            return "Line Chart with Lollipop"
        case .animatingLine:
            return "Animating Line"
        case .gradientLine:
            return "Line with changing gradient"
        case .multiLine:
            return "Line Charts"
        case .linePoint:
            return "Line Point"
        case .singleBar:
            return "Single Bar"
        case .singleBarThreshold:
            return "Single Bar with Threshold Rule Mark"
        case .twoBars:
            return "Two Bars"
        case .scrollingBar:
            return "Horizontal Scrolling Bar Chart"
        case .pyramid:
            return "Pyramid"
        case .timeSheetBar:
            return "Time Sheet Bar"
        #if canImport(UIKit)
        case .soundBar:
            return "Sound Bar"
        #endif
        case .areaSimple:
            return "Area Chart"
        case .stackedArea:
            return "Stacked Area Chart"
        case .rangeSimple:
            return "Range Chart"
        case .rangeHeartRate:
            return "Heart Rate Range Chart"
        case .candleStick:
            return "Candle Stick Chart"
        case .customizeableHeatMap:
            return "Customizable Heat Map"
        case .gitContributions:
            return "GitHub Contributions Graph"
        case .scatter:
            return "Scatter Chart"
        case .vectorField:
            return "Vector Field"
        }
    }

    var category: ChartCategory {
        switch self {
        case .heartBeat, .screenTime, .oneDimensionalBar:
            return .apple
        case .singleLine, .singleLineLollipop, .animatingLine, .gradientLine, .multiLine, .linePoint:
            return .line
        case .singleBar, .singleBarThreshold, .twoBars, .pyramid, .timeSheetBar:
            return .bar
        #if canImport(UIKit)
        case .soundBar:
            return .bar
        #endif
        case .areaSimple, .stackedArea:
            return .area
        case .rangeSimple, .rangeHeartRate, .candleStick:
            return .range
        case .customizeableHeatMap, .gitContributions:
            return .heatMap
        case .scatter, .vectorField:
            return .point
        case .scrollingBar:
            return .bar
        }
    }

    var view: some View {
        let example = allData.overViewExample7
        return overviewOrDetailView(isOverview: true,reps: example.0,weight: example.1)
    }
    
    var chartDescriptor: AXChartDescriptor? {
        // This is necessary since we use images for preview/overview
        // TODO: Use protocol conformance to remove manual switch necessity
        let example = allData.overViewExample7
        switch self {
        case .singleLineLollipop:
            return SingleLineLollipop(isOverview: true,reps: example.0,weight: example.1).makeChartDescriptor()
        default:
            return nil

        }
    }

    var detailView: some View {
        let example = allData.overViewExample7
        return overviewOrDetailView(isOverview: false,reps: example.0,weight: example.1)
    }

    @ViewBuilder
    private func overviewOrDetailView(isOverview: Bool,reps:[RepsData],weight:[WeightData]) -> some View {
        SingleLineLollipop(isOverview: isOverview,reps:reps,weight:weight)
        }
}
