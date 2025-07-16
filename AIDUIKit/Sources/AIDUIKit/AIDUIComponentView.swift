//
//  AIDUIComponentView.swift
//  AIDUIKit
//
//  Created by Patricio Reyes on 11/30/24.
//

import SwiftUI

/// Protocol for SwiftUI views that can be used as AIDUI components
/// 
/// Conforming views must be initializable with a scheme that defines their configuration.
/// This protocol enables type-safe component creation while maintaining flexibility.
public protocol AIDUIComponentView<Scheme>: View {
    /// The scheme type that configures this component
    associatedtype Scheme: AIDUIComponentScheme
    
    /// Creates a new instance of the component with the given scheme
    /// - Parameter scheme: The configuration scheme for this component
    init(scheme: Scheme)
}

// MARK: - Convenience Extensions

public extension AIDUIComponentView {
    /// Creates a component builder function for use with AIDUIComponentFactory
    /// - Returns: A component builder function
    static func builder() -> AIDUIComponentFactory.ComponentBuilder {
        return { data in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let component = try decoder.decode(AIDUIComponent<Scheme>.self, from: data)
                return AnyView(Self(scheme: component.arguments))
            } catch {
                print("❌ Error decoding \(String(describing: Self.self)): \(error)")
                return AnyView(EmptyView())
            }
        }
    }
}

// MARK: - Registration Helper

public extension AIDUIComponentFactory {
    /// Registers a component view type with the factory
    /// - Parameters:
    ///   - componentType: The component view type to register
    ///   - name: The name to register the component under (defaults to the type name)
    func register<T: AIDUIComponentView>(_ componentType: T.Type, as name: String? = nil) {
        let componentName = name ?? String(describing: componentType)
        register(component: componentName, builder: componentType.builder())
    }
} 