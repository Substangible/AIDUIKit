//
//  AIDUIComponent.swift
//  AIDUIKit
//
//  Created by Patricio Reyes on 08/09/23.
//

import Foundation

/// A generic component that can be used to represent any UI component in the AIDUI system.
/// 
/// Components are defined by a name and a set of arguments that conform to the `AIDUIComponentScheme` protocol.
/// This allows for type-safe component creation while maintaining flexibility for different component types.
public struct AIDUIComponent<T: AIDUIComponentScheme>: Codable, Hashable {
    /// The name of the component, used to identify which component builder to use
    public let name: String
    
    /// The arguments/configuration for this component instance
    public let arguments: T
    
    /// Creates a new AIDUIComponent
    /// - Parameters:
    ///   - name: The component name
    ///   - arguments: The component arguments
    public init(name: String, arguments: T) {
        self.name = name
        self.arguments = arguments
    }
}

/// Protocol that all component schemes must conform to
/// 
/// Component schemes define the structure and data required for a specific component type.
/// They must be Codable for JSON serialization and Hashable for efficient comparison.
public protocol AIDUIComponentScheme: Codable, Hashable {}

/// Empty scheme for components that don't require any arguments
public struct EmptyScheme: AIDUIComponentScheme {
    public init() {}
} 