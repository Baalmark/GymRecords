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
    var reps:[RepsData]
    var weight:[WeightData]
    @State private var periodXAxis = ("","")
    @State private var lineWidth = 2.0
    @State private var chartColor: Color = .black
    @StateObject var statisticViewModel:StatisticViewModel = StatisticViewModel()
    @State private var selectedElementRep: RepsData? = nil
    @State private var selectedElementWeights: WeightData? = nil
    @State private var showLollipop = true
    @State private var lollipopColor: Color = .black
    @State private var axisValueForWeight:Double = 0
    @State private var axisValueForReps:Double = 0
    
    let previewChartHeight: CGFloat = UIScreen.main.bounds.height / 3
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.4),         Color.black.opacity(0)]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    
    @State var data:([RepsData],[WeightData]) = allData.overViewExample7
    
   
    var body: some View {
            mainBody
                .navigationBarTitle(ChartType.singleLineLollipop.title, displayMode: .inline)
    }
    
    var mainBody: some View {
        VStack(alignment:.leading) {
            Section {
                HStack {
                    Text("Reps")
                        .fontWeight(.semibold)
                        .font(.title)
                        .padding(.leading,20)
                    Text("max \(statisticViewModel.getMaxRep(reps:reps).removeZerosFromEnd())")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("GrayColor"))
                }
                repChart
                    .allowsHitTesting(true)
                    .padding([.leading,.top,.trailing])
                
                HStack {
                    Text("\(periodXAxis.0)")
                    Spacer()
                    Text("\(periodXAxis.1)")
                }
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(Color("MidGrayColor"))
                .padding([.leading,.trailing])
                .onAppear {
                    periodXAxis = viewModel.returnStartAndEndOfPeriodForChart(startPoint: data.0.first?.day ?? Date(), endPoint: data.0.last?.day ?? Date())
                }
                .onChange(of: viewModel.selectedPeriod) { _ in
                    periodXAxis = viewModel.returnStartAndEndOfPeriodForChart(startPoint: data.0.first?.day ?? Date(), endPoint: data.0.last?.day ?? Date())

                }
                    
                
            }
            .padding(.bottom,20)
            Section {
                HStack {
                    Text("Weight lifted")
                        .fontWeight(.semibold)
                        .font(.title)
                        .padding(.leading,20)
                    Text("max \(statisticViewModel.getMaxWeight(weights:weight).removeZerosFromEnd())")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("GrayColor"))
                }
                weightChart
                    .allowsTightening(true)
                    .padding([.leading,.top,.trailing])
                
                HStack {
                    Text("\(periodXAxis.0)")
                    Spacer()
                    Text("\(periodXAxis.1)")
                }
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(Color("MidGrayColor"))
                .padding([.leading,.trailing])
            }
            .padding(.bottom,20)
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
    
    private var repChart: some View {
        Chart(data.0, id: \.day) { chartMarker in
            let baselineMarker = statisticViewModel.getBaselineMarkerReps(marker: chartMarker)
            let baselineMarkerBack = statisticViewModel.getBaselineMarkerRepsBack(marker:chartMarker)
            if statisticViewModel.compareSelectedMarkerToChartMarker(selectedMarker: selectedElementRep, chartMarker: chartMarker) && showLollipop {
                baselineMarker.symbol() {
                    Circle().strokeBorder(chartColor, lineWidth: 2).background(Circle().foregroundColor(lollipopColor)).frame(width: 7)
                }
            } else {
                baselineMarker.symbol(Circle().strokeBorder(lineWidth: lineWidth))
                    .foregroundStyle(linearGradient)
            }
            baselineMarkerBack.symbol() {
                Circle().strokeBorder(chartColor, lineWidth: 2).background(Circle().foregroundColor(lollipopColor)).frame(width: 7)
            }
        }
        
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = statisticViewModel.findElementReps(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElementRep?.day == element?.day {
                                    // If tapping the same element, clear the selection.
                                    selectedElementRep = nil
                                } else {
                                    selectedElementRep = element
                                }
                            }
                        
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElementRep = statisticViewModel.findElementReps(location: value.location, proxy: proxy, geometry: geo)
                                    }
                            )
                        
                    )
                
            }
        }
        
        .chartBackground { proxy in
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if showLollipop,
                       let selectedElementRep {
                        let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElementRep.day)!
                        let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                        
                        let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                        let lineHeight = geo[proxy.plotAreaFrame].maxY
                        let boxWidth: CGFloat = 100
                        
                        let boxOffset = max(0, min(geo.size.width - boxWidth, lineX - boxWidth / 2))
                        
                        HStack {
                            Text("\(selectedElementRep.reps, format: .number) ")
                                .font(.custom("Helvetica", size: 13).bold())
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(selectedElementRep.day, format: .dateTime.year().month().day())")
                                .font(.custom("Helvetica", size: 11).bold())
                                .foregroundStyle(Color("GrayColor"))
                            
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHidden(false)
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
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: [0, viewModel.maxSummaryReps ?? 0 * 1.5 ])
        .frame(height: previewChartHeight)
    }
    
    private var weightChart: some View {
        Chart(data.1, id: \.day) { chartMarker in
            let baselineMarker = statisticViewModel.getBaselineMarkerWeight(marker: chartMarker)
            let baselineMarkerBack = statisticViewModel.getBaselineMarkerWeightBack(marker: chartMarker)
            if statisticViewModel.compareSelectedMarkerToChartMarker(selectedMarker: selectedElementWeights, chartMarker: chartMarker) && showLollipop {
                baselineMarker.symbol() {
                    Circle().strokeBorder(chartColor, lineWidth: 2).background(Circle().foregroundColor(lollipopColor)).frame(width: 7)
                }
            } else {
                baselineMarker.symbol(Circle().strokeBorder(lineWidth: lineWidth))
                    .foregroundStyle(linearGradient)
            }
            baselineMarkerBack.symbol() {
                Circle().strokeBorder(chartColor, lineWidth: 2).background(Circle().foregroundColor(lollipopColor)).frame(width: 7)
            }
        }
        
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = statisticViewModel.findElementWeight(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElementWeights?.day == element?.day {
                                    // If tapping the same element, clear the selection.
                                    selectedElementWeights = nil
                                } else {
                                    selectedElementWeights = element
                                }
                            }
                        
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElementWeights = statisticViewModel.findElementWeight(location: value.location, proxy: proxy, geometry: geo)
                                    }
                            )
                        
                    )
                
            }
        }
        
        .chartBackground { proxy in
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if showLollipop,
                       let selectedElementWeights {
                        let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElementWeights.day)!
                        let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                        
                        let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                        let lineHeight = geo[proxy.plotAreaFrame].maxY
                        let boxWidth: CGFloat = 100
                        
                        let boxOffset = max(0, min(geo.size.width - boxWidth, lineX - boxWidth / 2))
                        
                        HStack {
                            Text("\(selectedElementWeights.weight, format: .number) ")
                                .font(.custom("Helvetica", size: 13).bold())
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(selectedElementWeights.day, format: .dateTime.year().month().day())")
                                .font(.custom("Helvetica", size: 11).bold())
                                .foregroundStyle(Color("GrayColor"))
                            
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHidden(false)
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
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: [0, viewModel.maxSummaryWeight ?? 0 * 1.5])
        .accessibilityChartDescriptor(self)
        
        .frame(height: previewChartHeight)
    }
    
}

// MARK: - Accessibility

extension ChartsView: AXChartDescriptorRepresentable {
    
    
    func makeChartDescriptor() -> AXChartDescriptor {
        AccessibilityHelpers.chartDescriptorReps(forCountSeries: data.0)
    }
}



// Legacy

//        .chartXAxis {
//            AxisMarks(values: .stride(by: .day, count: 1)) { _ in
//                AxisValueLabel(format: .dateTime.month().day())
//            }
//        }
