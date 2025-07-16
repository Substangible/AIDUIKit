//
//  CustomChartVieew.swift
//  AIDrivenUI
//
//  Created by Patricio Reyes on 09/09/23.
//

import Charts
import SwiftUI
import AIDUIKit

public struct SeriesChartView: AIDUIComponentView {
    
    let series: [Series]
    let xLabel: String
    let style: SeriesChartStyle?
        
    public init(scheme: SeriesChartScheme) {
        self.init(series: scheme.series, xLabel: scheme.xLabel, style: scheme.style)
    }
    
    public init(series: [Series], xLabel: String, style: SeriesChartStyle? = nil) {
        self.series = series
        self.xLabel = xLabel
        self.style = style
    }
    
    private var lineWidth: CGFloat {
        style?.lineWidth ?? 3
    }
    
    private var symbolSize: CGFloat {
        style?.symbolSize ?? 100
    }
    
    private var shouldShowGrid: Bool {
        style?.showGrid ?? true
    }
    
    private var backgroundColor: Color {
        if let colorString = style?.backgroundColor {
            return Color(hex: colorString) ?? .clear
        }
        return .clear
    }
    
    private var cornerRadius: CGFloat {
        style?.cornerRadius ?? 0
    }
    
    private var shouldShowLegend: Bool {
        style?.showLegend ?? true
    }
    
    private var chartLegendVisibility: Visibility {
        shouldShowLegend ? .automatic : .hidden
    }

    public var body: some View {
        Chart {
            ForEach(series, id: \.name) { series in
                ForEach(series.data, id: \.self) { element in
                    LineMark(
                        x: .value(xLabel, element.xValue),
                        y: .value("Sales", element.yValue)
                    )
                }
                .symbol(by: .value(xLabel, series.name))
            }
            .interpolationMethod(.catmullRom)
            .lineStyle(StrokeStyle(lineWidth: lineWidth))
            .symbolSize(symbolSize)

        }
        .chartYAxis {
            AxisMarks { value in
                if shouldShowGrid {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.gray.opacity(0.3))
                }
                AxisValueLabel()
            }
        }
        .chartXAxis {
            AxisMarks { value in
                if shouldShowGrid {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.gray.opacity(0.3))
                }
                AxisValueLabel()
            }
        }
        .chartYScale(range: .plotDimension(endPadding: 8))
        .chartLegend(chartLegendVisibility)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}


//struct LocationsOverview: View {
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Day + Location with Most Sales")
//                .foregroundStyle(.secondary)
//            Text("Sundays in San Francisco")
//                .font(.title2.bold())
//            SeriesChartView(scheme: UIComponentType.locationsOverview.example)
//                .frame(height: 100)
//        }
//    }
//}

/// A square symbol for charts.
struct Square: ChartSymbolShape, InsettableShape {
    let inset: CGFloat

    init(inset: CGFloat = 0) {
        self.inset = inset
    }

    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 1
        let minDimension = min(rect.width, rect.height)
        return Path(
            roundedRect: .init(x: rect.midX - minDimension / 2, y: rect.midY - minDimension / 2, width: minDimension, height: minDimension),
            cornerRadius: cornerRadius
        )
    }

    func inset(by amount: CGFloat) -> Square {
        Square(inset: inset + amount)
    }

    var perceptualUnitRect: CGRect {
        // The width of the unit rectangle (square). Adjust this to
        // size the diamond symbol so it perceptually matches with
        // the circle.
        let scaleAdjustment: CGFloat = 0.75
        return CGRect(x: 0.5 - scaleAdjustment / 2, y: 0.5 - scaleAdjustment / 2, width: scaleAdjustment, height: scaleAdjustment)
    }
}
//
//#Preview {
//    LocationsOverview()
//        .padding()
//}

func date(year: Int, month: Int, day: Int = 1) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
}

