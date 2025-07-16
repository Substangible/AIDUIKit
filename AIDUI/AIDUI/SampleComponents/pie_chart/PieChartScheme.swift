//
//  PieChartScheme.swift
//  AIDrivenUI
//
//  Created by Patricio Reyes on 09/09/23.
//

import Foundation
import AIDUIKit

public struct PieChartScheme: AIDUIComponentScheme {
    let data: [PieChartSegment]
    let style: PieChartStyle?
}

public struct PieChartStyle: Codable, Hashable {
    let colorPalette: [String]?    // Custom colors for segments
    let innerRadius: Double?       // Donut hole size (0.0 = full pie)
    let cornerRadius: Double?      // Segment corner radius
    let showLegend: Bool?         // Show/hide legend
    let legendPosition: String?    // "top", "bottom", "left", "right"
    let backgroundColor: String?   // Chart background
}

public struct PieChartSegment: Codable, Hashable, Identifiable {
    let name: String
    let value: Double
    public var id: String { name }
}
