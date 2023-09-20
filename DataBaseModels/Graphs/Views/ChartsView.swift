//
//  ChartsView.swift
//  GymRecords
//
//  Created by Pavel Goldman on 18.09.2023.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @EnvironmentObject var viewModel:GymViewModel
    var isOverview: Bool
    var reps:[RepsData]
    var weight:[WeightData]
    
    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .monotone
    @State private var chartColor: Color = .black
    var statisticViewModel:StatisticViewModel = StatisticViewModel()
    @State private var showSymbols = true
    @State private var selectedElementReps: RepsData? = nil
    @State private var selectedElementWeight: WeightData? = nil
    @State private var showLollipop = true
    @State private var lollipopColor: Color = .black
    @State private var axisValueForWeight:Double = 0
    @State private var axisValueForReps:Double = 0
    let previewChartHeight: CGFloat = UIScreen.main.bounds.height / 3
    
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.4),         Color.black.opacity(0)]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    
    @State var data:([RepsData],[WeightData]) = allData.overViewExample7
    
   
    var body: some View {
        if !isOverview {
            mainBody
                .navigationBarTitle(ChartType.singleLineLollipop.title, displayMode: .inline)
        }
    }
    
    var mainBody: some View {
        VStack(alignment:.leading) {
            Section {
                HStack {
                    Text("Reps")
                        .fontWeight(.semibold)
                        .font(.title)
                        .padding(.leading,20)
                    Text("max \(getMaxRep(reps:reps).removeZerosFromEnd())")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("GrayColor"))
                }
                repChart
                    .allowsHitTesting(true)
                    .padding()
                    
                
            }
            Section {
                HStack {
                    Text("Weight lifted")
                        .fontWeight(.semibold)
                        .font(.title)
                        .padding(.leading,20)
                    Text("max \(getMaxWeight(weights:weight).removeZerosFromEnd())")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("GrayColor"))
                }
                weightChart
                    .allowsTightening(true)
                    .padding()
            }
            Section {
                Text("History")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
            }

        }
        .onAppear {
            if let exercise = viewModel.selectedExerciseForStatisticView {
                data = statisticViewModel.getlastPeriod(exercise: exercise , period: viewModel.selectedPeriod)
                
                viewModel.maxSummaryReps = data.0.max { $0.reps < $1.reps}?.reps
                viewModel.maxSummaryWeight = data.1.max { $0.weight < $1.weight}?.weight
            }
        }
        .onChange(of:viewModel.selectedPeriod) { newValue in
            if let exercise = viewModel.selectedExerciseForStatisticView {
                data = statisticViewModel.getlastPeriod(exercise: exercise , period: viewModel.selectedPeriod)
                
                viewModel.maxSummaryReps = data.0.max { $0.reps < $1.reps}?.reps
                viewModel.maxSummaryWeight = data.1.max { $0.weight < $1.weight}?.weight
            }
        }
        
    }
    
    private func CompareSelectedMarkerToChartMarker<T: Equatable>(selectedMarker: T, chartMarker: T) -> Bool {
        return selectedMarker == chartMarker
    }
    
    
    
    private func getBaselineMarkerReps(marker: RepsData) -> some ChartContent {
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
    private func getBaselineMarkerWeight(marker: WeightData) -> some ChartContent {
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
    private func getBaselineMarkerRepsBack(marker: RepsData) -> some ChartContent {
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
    private func getBaselineMarkerWeightBack(marker: WeightData) -> some ChartContent {
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
    
    private var repChart: some View {
        Chart(data.0, id: \.day) { chartMarker in
            let baselineMarker = getBaselineMarkerReps(marker: chartMarker)
            let baselineMarkerBack = getBaselineMarkerRepsBack(marker:chartMarker)
            if CompareSelectedMarkerToChartMarker(selectedMarker: selectedElementReps, chartMarker: chartMarker) && showLollipop {
                baselineMarker.symbol() {
                    Circle().strokeBorder(chartColor, lineWidth: 2).background(Circle().foregroundColor(lollipopColor)).frame(width: 11)
                }
            } else {
                baselineMarker.symbol(Circle().strokeBorder(lineWidth: lineWidth))
                    .foregroundStyle(linearGradient)
            }
            baselineMarkerBack.symbol() {
                Circle().strokeBorder(chartColor, lineWidth: 2).background(Circle().foregroundColor(lollipopColor)).frame(width: 11)
            }
        }
        
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElementReps(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElementReps?.day == element?.day {
                                    // If tapping the same element, clear the selection.
                                    selectedElementReps = nil
                                } else {
                                    selectedElementReps = element
                                }
                            }
                        
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElementReps = findElementReps(location: value.location, proxy: proxy, geometry: geo)
                                    }
                            )
                        
                    )
                
            }
        }
        
        .chartBackground { proxy in
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if showLollipop,
                       let selectedElementReps {
                        let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElementReps.day)!
                        let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                        
                        let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                        let lineHeight = geo[proxy.plotAreaFrame].maxY
                        let boxWidth: CGFloat = 100
                        
                        let boxOffset = max(0, min(geo.size.width - boxWidth, lineX - boxWidth / 2))
                        
                        Rectangle()
                            .fill(lollipopColor)
                            .frame(width: 2, height: 0)
                            .position(x: lineX, y: lineHeight / 2)
                        
                        HStack {
                            Text("\(selectedElementReps.reps, format: .number) ")
                                .font(.custom("Helvetica", size: 13).bold())
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(selectedElementReps.day, format: .dateTime.year().month().day())")
                                .font(.custom("Helvetica", size: 11).bold())
                                .foregroundStyle(Color("GrayColor"))
                            
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHidden(isOverview)
                        .frame(width: boxWidth, alignment: .leading)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.background)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("backgroundDarkColor"))
                            }
                            .padding(.horizontal, -8)
                            .padding(.vertical, -4)
                        }
                        .offset(x: boxOffset)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 1)) { _ in
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .chartYScale(domain: [0, viewModel.maxSummaryReps ?? 0 * 1.5 ])
        .frame(height: isOverview ? previewChartHeight : previewChartHeight)
    }
    
    
    func testFunc(repsTrueWeightFalse:Bool)  {
        
    }
    private var weightChart: some View {
        Chart(data.1, id: \.day) { chartMarker in
            let baselineMarker = getBaselineMarkerWeight(marker: chartMarker)
            let baselineMarkerBack = getBaselineMarkerWeightBack(marker: chartMarker)
            if CompareSelectedMarkerToChartMarker(selectedMarker: selectedElementWeight, chartMarker: chartMarker) && showLollipop {
                baselineMarker.symbol() {
                    Circle().strokeBorder(chartColor, lineWidth: 2).background(Circle().foregroundColor(lollipopColor)).frame(width: 11)
                }
            } else {
                baselineMarker.symbol(Circle().strokeBorder(lineWidth: lineWidth))
                    .foregroundStyle(linearGradient)
            }
            baselineMarkerBack.symbol() {
                Circle().strokeBorder(chartColor, lineWidth: 2).background(Circle().foregroundColor(lollipopColor)).frame(width: 11)
            }
        }
        
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElementWeight(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElementWeight?.day == element?.day {
                                    // If tapping the same element, clear the selection.
                                    selectedElementWeight = nil
                                } else {
                                    selectedElementWeight = element
                                }
                            }
                        
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElementWeight = findElementWeight(location: value.location, proxy: proxy, geometry: geo)
                                    }
                            )
                        
                    )
                
            }
        }
        
        .chartBackground { proxy in
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if showLollipop,
                       let selectedElementWeight {
                        let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElementWeight.day)!
                        let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                        
                        let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                        let lineHeight = geo[proxy.plotAreaFrame].maxY
                        let boxWidth: CGFloat = 100
                        
                        let boxOffset = max(0, min(geo.size.width - boxWidth, lineX - boxWidth / 2))
                        
                        Rectangle()
                            .fill(lollipopColor)
                            .frame(width: 2, height: 0)
                            .position(x: lineX, y: lineHeight / 2)
                        
                        HStack {
                            Text("\(selectedElementWeight.weight, format: .number) ")
                                .font(.custom("Helvetica", size: 13).bold())
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(selectedElementWeight.day, format: .dateTime.year().month().day())")
                                .font(.custom("Helvetica", size: 11).bold())
                                .foregroundStyle(Color("GrayColor"))
                            
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHidden(isOverview)
                        .frame(width: boxWidth, alignment: .leading)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.background)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("backgroundDarkColor"))
                            }
                            .padding(.horizontal, -8)
                            .padding(.vertical, -4)
                        }
                        .offset(x: boxOffset)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 1)) { _ in
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
        .chartXAxis(isOverview ? .hidden : .visible)
        .chartYAxis(isOverview ? .hidden : .visible)
        .chartYScale(domain: [0, viewModel.maxSummaryWeight ?? 0 * 1.5])
        .accessibilityChartDescriptor(self)
        
        .frame(height: isOverview ? previewChartHeight : previewChartHeight)
    }
    
    private func findElementReps(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> RepsData? {
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
    
    private func findElementWeight(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> WeightData? {
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
    private func getMaxRep(reps:[RepsData]) -> Double {
        var temp:Double = 0
        for rep in reps {
            if temp < rep.reps {
                temp = rep.reps
            }
        }
        
        return temp.rounded(.awayFromZero)
    }
    //MARK: Max weight getter
    private func getMaxWeight(weights:[WeightData]) -> Double {
        var temp:Double = 0
        for weight in weights {
            if temp < weight.weight {
                temp = weight.weight
            }
        }
        
        return temp.rounded(.awayFromZero)
    }
}

// MARK: - Accessibility

extension ChartsView: AXChartDescriptorRepresentable {
    
    
    func makeChartDescriptor() -> AXChartDescriptor {
        AccessibilityHelpers.chartDescriptorReps(forCountSeries: data.0)
    }
}



