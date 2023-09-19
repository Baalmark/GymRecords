//
//  ChartType.swift
//  GymRecords
//
//  Created by Pavel Goldman on 18.09.2023.
//

import SwiftUI

enum ChartCategory: String, CaseIterable, Hashable, Identifiable {
    case line


    var id: String { self.rawValue }

}

enum ChartType: String, Identifiable, CaseIterable {

    // Line Charts
    case singleLine
    case singleLineLollipop
    case animatingLine
    case gradientLine
    case multiLine
    case linePoint


    var id: String { self.rawValue }

    var title: String {
        switch self {
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
        
        }
    }

    var category: ChartCategory {
        switch self {
        case .singleLine, .singleLineLollipop, .animatingLine, .gradientLine, .multiLine, .linePoint:
            return .line

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
            return ChartsView(isOverview: true,reps: example.0,weight: example.1).makeChartDescriptor()
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
        ChartsView(isOverview: isOverview,reps:reps,weight:weight,data:allData.overViewExample7)
        }
}
