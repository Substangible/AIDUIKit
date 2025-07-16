//
//  LineChartScheme.swift
//  AIDrivenUI
//
//  Created by Patricio Reyes on 09/09/23.
//

import Foundation
import AIDUIKit

public struct LineChartScheme: AIDUIComponentScheme {
    let title: String?
    let data: [LineChartDataPoint]
    let style: LineChartStyle?
}

public struct LineChartStyle: Codable, Hashable {
    let primaryColor: String?      // Line color
    let backgroundColor: String?   // Chart background
    let titleFontSize: Double?     // Title text size
    let titleColor: String?        // Title text color
    let lineWidth: Double?         // Line thickness
    let showGrid: Bool?           // Show/hide grid lines
    let cornerRadius: Double?      // Chart corner radius
}

public struct LineChartDataPoint: Codable, Hashable, Identifiable {
    let xValue: String
    let yValue: Double
    public var id: String { xValue }
}
