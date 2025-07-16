//
//  ColorExtensions.swift
//  AIDUI
//
//  Created by Patricio Reyes on 7/15/25.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        let r, g, b: Double
        
        let hexString = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        guard hexString.count == 6 else {
            return nil
        }
        
        let scanner = Scanner(string: hexString)
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else {
            return nil
        }
        
        r = Double((hexNumber & 0xff0000) >> 16) / 255
        g = Double((hexNumber & 0x00ff00) >> 8) / 255
        b = Double(hexNumber & 0x0000ff) / 255
        
        self.init(red: r, green: g, blue: b)
    }
} 