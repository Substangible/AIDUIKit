//
//  AIDUIComponentContainerView.swift
//  AIDUIKit
//
//  Created by Patricio Reyes on 08/09/23.
//

import SwiftUI

/// A SwiftUI view that renders components using the AIDUIComponentFactory
/// 
/// This view acts as a bridge between component data and SwiftUI views,
/// using the factory to create the appropriate view based on the component data.
public struct AIDUIComponentContainerView: View {
    private let factory: AIDUIComponentFactory
    private var data: [String: AnyCodable]
    private var errorView: AnyView?
    private var hasError: Bool = false
    
    /// Creates a new container view
    /// - Parameters:
    ///   - data: The component data dictionary
    ///   - factory: The factory to use for creating views
    public init(
        _ data: [String: AnyCodable],
        factory: AIDUIComponentFactory
    ) {
        self.data = data
        self.factory = factory
        self.errorView = nil
        self.hasError = false
    }
    
    /// Creates a new container view with JSON data
    /// - Parameters:
    ///   - jsonData: The component data as JSON Data
    ///   - factory: The factory to use for creating views
    public init(
        jsonData: Data,
        factory: AIDUIComponentFactory
    ) throws {
        let decoder = JSONDecoder()
        let dictionary = try decoder.decode([String: AnyCodable].self, from: jsonData)
        self.init(dictionary, factory: factory)
    }
    
    /// SwiftUI-friendly initializer with optional error handling
    /// - Parameters:
    ///   - jsonData: The component data as JSON Data
    ///   - factory: The factory to use for creating views
    ///   - errorView: Optional view to show when parsing fails
    public init<ErrorView: View>(
        jsonData: Data,
        factory: AIDUIComponentFactory,
        errorView: (() -> ErrorView)? = nil
    ) {
        self.factory = factory
        
        do {
            let decoder = JSONDecoder()
            let dictionary = try decoder.decode([String: AnyCodable].self, from: jsonData)
            self.data = dictionary
            self.hasError = false
            self.errorView = nil
        } catch {
            self.data = [:]
            self.hasError = true
            if let errorView = errorView {
                self.errorView = AnyView(errorView())
            } else {
                self.errorView = AnyView(
                    Text("Failed to parse component: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .font(.caption)
                )
            }
        }
    }
    
    /// SwiftUI-friendly initializer for JSON strings with optional error handling
    /// - Parameters:
    ///   - jsonString: The component data as JSON string
    ///   - factory: The factory to use for creating views
    ///   - errorView: Optional view to show when parsing fails
    public init<ErrorView: View>(
        jsonString: String,
        factory: AIDUIComponentFactory,
        errorView: (() -> ErrorView)? = nil
    ) {
        self.factory = factory
        
        guard let data = jsonString.data(using: .utf8) else {
            self.data = [:]
            self.hasError = true
            if let errorView = errorView {
                self.errorView = AnyView(errorView())
            } else {
                self.errorView = AnyView(
                    Text("Invalid JSON string")
                        .foregroundColor(.red)
                        .font(.caption)
                )
            }
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let dictionary = try decoder.decode([String: AnyCodable].self, from: data)
            self.data = dictionary
            self.hasError = false
            self.errorView = nil
        } catch {
            self.data = [:]
            self.hasError = true
            if let errorView = errorView {
                self.errorView = AnyView(errorView())
            } else {
                self.errorView = AnyView(
                    Text("Failed to parse component: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .font(.caption)
                )
            }
        }
    }
    
    /// Type-safe initializer for pre-built components
    /// - Parameters:
    ///   - component: A type-safe component object
    ///   - factory: The factory to use for creating views
    ///   - errorView: Optional view to show when encoding fails
    public init<T: AIDUIComponentScheme, ErrorView: View>(
        component: AIDUIComponent<T>,
        factory: AIDUIComponentFactory,
        errorView: (() -> ErrorView)? = nil
    ) {
        self.factory = factory
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(component)
            
            let decoder = JSONDecoder()
            let dictionary = try decoder.decode([String: AnyCodable].self, from: data)
            self.data = dictionary
            self.hasError = false
            self.errorView = nil
        } catch {
            self.data = [:]
            self.hasError = true
            if let errorView = errorView {
                self.errorView = AnyView(errorView())
            } else {
                self.errorView = AnyView(
                    Text("Failed to encode component: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .font(.caption)
                )
            }
        }
    }
    
    public var body: some View {
        if hasError, let errorView = errorView {
            errorView
        } else {
            factory.makeView(from: data)
        }
    }
}

// MARK: - Convenience Initializers

public extension AIDUIComponentContainerView {
    /// Creates a container view from a JSON string
    /// - Parameters:
    ///   - jsonString: The component data as a JSON string
    ///   - factory: The factory to use for creating views
    init(jsonString: String, factory: AIDUIComponentFactory) throws {
        guard let data = jsonString.data(using: .utf8) else {
            throw AIDUIComponentError.invalidJSONString
        }
        try self.init(jsonData: data, factory: factory)
    }
    
    /// Type-safe convenience initializer without error view
    /// - Parameters:
    ///   - component: A type-safe component object
    ///   - factory: The factory to use for creating views
    init<T: AIDUIComponentScheme>(
        component: AIDUIComponent<T>,
        factory: AIDUIComponentFactory
    ) throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(component)
        try self.init(jsonData: data, factory: factory)
    }
}

// MARK: - Error Types

public enum AIDUIComponentError: Error, LocalizedError {
    case invalidJSONString
    case decodingFailed(Error)
    case componentNotFound(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidJSONString:
            return "Invalid JSON string provided"
        case .decodingFailed(let error):
            return "Failed to decode component data: \(error.localizedDescription)"
        case .componentNotFound(let name):
            return "Component '\(name)' not found in factory"
        }
    }
} 