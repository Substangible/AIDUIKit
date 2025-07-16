//
//  SeriesChartScheme.swift
//  AIDrivenUI
//
//  Created by Patricio Reyes on 09/09/23.
//

import Foundation
import AIDUIKit

public struct SeriesChartScheme: AIDUIComponentScheme, Codable, Hashable {
    let series: [Series]
    let xLabel: String = "XLabel"
    let style: SeriesChartStyle?
}

public struct SeriesChartStyle: Codable, Hashable {
    let colorPalette: [String]?    // Colors for different series
    let lineWidth: Double?         // Line thickness
    let symbolSize: Double?        // Data point size
    let showGrid: Bool?           // Show/hide grid
    let backgroundColor: String?   // Chart background
    let cornerRadius: Double?      // Chart corner radius
    let showLegend: Bool?         // Show/hide legend
}

public struct SeriesChartDataPoint: Codable, Hashable {
    let xValue: String
    let yValue: Double
}

public struct Series: Codable, Hashable {
    let name: String
    let data: [SeriesChartDataPoint]
}
