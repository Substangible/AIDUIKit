//
//  AIDUIComponentFactory.swift
//  AIDUI
//
//  Created by Patricio Reyes on 7/15/25.
//


import SwiftUI
import Foundation
import AIDUIKit

extension AIDUIComponentFactory {

    static let custom = AIDUIComponentFactory(
        componentBuilders: [
            "line_chart": { data in
                let component = try! JSONDecoder().decode(AIDUIComponent<LineChartScheme>.self, from: data)
                return AnyView(LineChartView(scheme: component.arguments))
            },
            "pie_chart": { data in
                let component = try! JSONDecoder().decode(AIDUIComponent<PieChartScheme>.self, from: data)
                return AnyView(PieChartView(scheme: component.arguments))
            },
            "series_chart": { data in
                let component = try! JSONDecoder().decode(AIDUIComponent<SeriesChartScheme>.self, from: data)
                return AnyView(SeriesChartView(scheme: component.arguments))
            }
        ])
}
