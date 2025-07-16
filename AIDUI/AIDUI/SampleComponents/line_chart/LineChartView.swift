//
//  LineChart.swift
//  AIDrivenUI
//
//  Created by Patricio Reyes on 08/09/23.
//

import SwiftUI
import Charts
import AIDUIKit

public struct LineChartView: AIDUIComponentView {
    var yAxisRange: ClosedRange<Double> {
        let minValue = (data.map { $0.yValue }.min() ?? 0) - 2
        let maxValue = (data.map { $0.yValue }.max() ?? 100) + 2
        return minValue...maxValue
    }
    
    var data: [LineChartDataPoint]
    var title: String?
    var style: LineChartStyle?
    
    @State private var selectedPoint: LineChartDataPoint?
    @State private var overlayXPosition: CGFloat = 0
    @State private var overlayYPosition: CGFloat = 0

    private let haptic = UIImpactFeedbackGenerator(style: .light)
    
    public init(scheme: LineChartScheme) {
        self.data = scheme.data
        self.title = scheme.title
        self.style = scheme.style
    }
    
    public init(data: [LineChartDataPoint], title: String? = nil) {
        self.data = data
        self.title = title
        self.style = nil
    }
    
    private var primaryColor: Color {
        if let colorString = style?.primaryColor {
            return Color(hex: colorString) ?? .blue
        }
        return .blue
    }
    
    private var backgroundColor: Color {
        if let colorString = style?.backgroundColor {
            return Color(hex: colorString) ?? .clear
        }
        return .clear
    }
    
    private var titleFontSize: CGFloat {
        style?.titleFontSize ?? 16
    }
    
    private var titleColor: Color {
        if let colorString = style?.titleColor {
            return Color(hex: colorString) ?? .primary
        }
        return .primary
    }
    
    private var lineWidth: CGFloat {
        style?.lineWidth ?? 2.5
    }
    
    private var shouldShowGrid: Bool {
        style?.showGrid ?? true
    }
    
    private var cornerRadius: CGFloat {
        style?.cornerRadius ?? 0
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let title {
                Text(title)
                    .font(.system(size: titleFontSize, weight: .semibold, design: .rounded))
                    .foregroundColor(titleColor)
            }
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Chart {
                        ForEach(data) { point in
                            LineMark(
                                x: .value("Date", point.xValue),
                                y: .value("Heart Rate", point.yValue)
                            )
                            .interpolationMethod(.linear)
                            .lineStyle(StrokeStyle(lineWidth: lineWidth))
                            .foregroundStyle(primaryColor)
                            
                            PointMark(
                                x: .value("Date", point.xValue),
                                y: .value("Heart Rate", point.yValue)
                            )
                            .symbol() {
                                Circle()
                                    .fill(point.id == selectedPoint?.id ? Color.orange : Color.white)
                                    .stroke(point.id == selectedPoint?.id ? Color.orange : primaryColor, lineWidth: 3)
                                    .frame(width: point.id == selectedPoint?.id ? 12 : 10)
                            }
                            .symbolSize(point.id == selectedPoint?.id ? 45 : 30)
                            .foregroundStyle(point.id == selectedPoint?.id ? primaryColor : Color.gray)
                        }
                        
                        if let selectedPoint {
                            RuleMark(x: .value("Selected Date", selectedPoint.xValue))
                                .foregroundStyle(.gray.opacity(0.3))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                            
                            RuleMark(y: .value("Selected Value", selectedPoint.yValue))
                                .foregroundStyle(.gray.opacity(0.3))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        }
                    }
                    .frame(height: 250)
                    .chartYScale(domain: yAxisRange)
                    .chartYAxis {
                        AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) { value in
                            if shouldShowGrid {
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                                    .foregroundStyle(Color.gray.opacity(0.3))
                            }
                            AxisValueLabel()
                                .foregroundStyle(.black)
                        }
                    }
                    .chartXAxis {
                        AxisMarks { value in
                            if shouldShowGrid {
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                                    .foregroundStyle(Color.gray.opacity(0.3))
                            }
                        }
                    }
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .chartOverlay { proxy in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        guard let plotFrame = proxy.plotFrame else { return }
                                        let origin = geometry[plotFrame].origin
                                        let location = CGPoint(
                                            x: value.location.x - origin.x,
                                            y: value.location.y - origin.y
                                        )
                                        
                                        guard let (date, _) = proxy.value(at: location, as: (String, Double).self) else {
                                            return
                                        }
                                        
                                        if let point = data.first(where: { $0.xValue == date }) {
                                            if point.id != selectedPoint?.id {
                                                haptic.impactOccurred()
                                                selectedPoint = point
                                            }
                                            overlayXPosition = value.location.x
                                            overlayYPosition = value.location.y
                                        }
                                    }
                            )
                    }
                    
                    // Floating overlay that follows x position
                    if let selectedPoint {
                        VStack(spacing: 4) {
                            Text(selectedPoint.xValue)
                                .font(.system(size: 14, weight: .medium))
                            Text("\(selectedPoint.yValue, specifier: "%.1f")")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            ZStack {
                                Color.white.opacity(0.8)
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .offset(x: min(max(overlayXPosition - geometry.size.width/2, -geometry.size.width/2 + 50), geometry.size.width/2 - 40), y: 0)
                    }
                }
            }
            .frame(height: 250)
        }
    }
}

#Preview {
    LineChartView(scheme:
                    LineChartScheme(
                        title: "Sleep",
                        data:[
                        LineChartDataPoint(xValue: "Sat 19", yValue: 53),
                        LineChartDataPoint(xValue: "Sun 20", yValue: 51),
                        LineChartDataPoint(xValue: "Mon 21", yValue: 59),
                        LineChartDataPoint(xValue: "Tue 22", yValue: 54),
                        LineChartDataPoint(xValue: "Wed 23", yValue: 52),
                        LineChartDataPoint(xValue: "Thu 24", yValue: 53),
                        LineChartDataPoint(xValue: "Fri 25", yValue: 52),
                        LineChartDataPoint(xValue: "Sat 26", yValue: 53),
                        LineChartDataPoint(xValue: "Sun 27", yValue: 51),
                        LineChartDataPoint(xValue: "Mon 28", yValue: 50)
                        ], style: nil)
    )
    .frame(height: 400)
}
