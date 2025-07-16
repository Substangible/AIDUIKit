//
//  PieChart.swift
//  AIDrivenUI
//
//  Created by Patricio Reyes on 09/09/23.
//

import Charts
import SwiftUI
import AIDUIKit

public struct PieChartView: AIDUIComponentView {
    
    @State var data: [PieChartSegment]
    var style: PieChartStyle?
    
    public init(scheme: PieChartScheme) {
        self.data = scheme.data
        self.style = scheme.style
    }
    
    public init(data: [PieChartSegment]) {
        self.data = data
        self.style = nil
    }
    
    private var innerRadius: Double {
        style?.innerRadius ?? 0.5
    }
    
    private var cornerRadius: Double {
        style?.cornerRadius ?? 3.0
    }
    
    private var shouldShowLegend: Bool {
        style?.showLegend ?? true
    }
    
    private var legendPosition: String {
        style?.legendPosition ?? "automatic"
    }
    
    private var backgroundColor: Color {
        if let colorString = style?.backgroundColor {
            return Color(hex: colorString) ?? .clear
        }
        return .clear
    }
    
    private var chartLegendVisibility: Visibility {
        shouldShowLegend ? .automatic : .hidden
    }

    public var body: some View {
        Chart(data, id: \.name) { element in
            SectorMark(
                angle: .value("Value", element.value),
                innerRadius: .ratio(innerRadius),
                angularInset: 1
            )
            .cornerRadius(cornerRadius)
            .foregroundStyle(by: .value("Name", element.name))
        }
        .chartLegend(chartLegendVisibility)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .background(backgroundColor)
        .padding(.horizontal, 20)
    }
}

#Preview {
    PieChartView(scheme: PieChartScheme(data: [
        .init(name: "Protein", value: 50),
        .init(name: "Carbs", value: 150),
        .init(name: "Fats", value: 20)
    ], style: nil))
    .padding()
}
