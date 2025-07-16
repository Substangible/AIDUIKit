//
//  AIDUIComponentFactory.swift
//  AIDUIKit
//
//  Created by Patricio Reyes on 09/09/23.
//

import SwiftUI

/// Factory class responsible for creating SwiftUI views from component data
/// 
/// The factory maintains a registry of component builders and can create views
/// dynamically based on component names and their associated data.
public class AIDUIComponentFactory: ObservableObject {
    /// Type alias for component builder functions
    /// - Parameter data: The JSON data for the component
    /// - Returns: A SwiftUI view wrapped in AnyView
    public typealias ComponentBuilder = (Data) -> AnyView
    
    private let decoder: JSONDecoder
    private var componentBuilders: [String: ComponentBuilder]

    /// Creates a new AIDUIComponentFactory
    /// - Parameters:
    ///   - decoder: JSON decoder to use for parsing component data
    ///   - componentBuilders: Initial set of component builders
    public init(
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }(),
        componentBuilders: [String: ComponentBuilder] = [:]
    ) {
        self.decoder = decoder
        self.componentBuilders = componentBuilders
    }

    /// Creates a SwiftUI view from a dictionary of component data
    /// - Parameter dictionary: The component data as a dictionary
    /// - Returns: A SwiftUI view, or EmptyView if creation fails
    public func makeView(from dictionary: [String: AnyCodable]) -> AnyView {
        do {
            let encoder = JSONEncoder()
            let processedData = try encoder.encode(dictionary)
            
            let base = try decoder.decode(AIDUIComponent<EmptyScheme>.self, from: processedData)
            
            if let builder = componentBuilders[base.name] {
                return builder(processedData)
            }
            
            print("⚠️ No builder found for component: \(base.name)")
            return AnyView(EmptyView())
        } catch {
            print("❌ Error creating component view: \(error)")
            return AnyView(EmptyView())
        }
    }

    /// Registers a new component builder
    /// - Parameters:
    ///   - name: The component name
    ///   - builder: The builder function
    public func register(component name: String, builder: @escaping ComponentBuilder) {
        componentBuilders[name] = builder
    }

    /// Unregisters a component builder
    /// - Parameter name: The component name to unregister
    public func unregister(component name: String) {
        componentBuilders.removeValue(forKey: name)
    }
    
    /// Returns all registered component names
    public var registeredComponents: [String] {
        Array(componentBuilders.keys).sorted()
    }
    
    /// Checks if a component is registered
    /// - Parameter name: The component name
    /// - Returns: True if the component is registered
    public func isRegistered(component name: String) -> Bool {
        componentBuilders[name] != nil
    }
} 