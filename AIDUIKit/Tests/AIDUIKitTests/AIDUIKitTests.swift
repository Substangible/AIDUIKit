import XCTest
@testable import AIDUIKit
import SwiftUI

final class AIDUIKitTests: XCTestCase {
    
    func testAIDUIComponentCreation() throws {
        // Test creating a component with empty scheme
        let component = AIDUIComponent(name: "test", arguments: EmptyScheme())
        XCTAssertEqual(component.name, "test")
    }
    
    func testComponentFactory() throws {
        let factory = AIDUIComponentFactory()
        
        // Test that factory starts with no registered components
        XCTAssertTrue(factory.registeredComponents.isEmpty)
        
        // Test registering a component
        factory.register(component: "test") { _ in
            AnyView(Text("Test Component"))
        }
        
        XCTAssertTrue(factory.isRegistered(component: "test"))
        XCTAssertEqual(factory.registeredComponents.count, 1)
        
        // Test unregistering
        factory.unregister(component: "test")
        XCTAssertFalse(factory.isRegistered(component: "test"))
        XCTAssertTrue(factory.registeredComponents.isEmpty)
    }
    
    func testAnyCodableEncoding() throws {
        let data: [String: AnyCodable] = [
            "name": AnyCodable("test"),
            "value": AnyCodable(42),
            "enabled": AnyCodable(true)
        ]
        
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(data)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode([String: AnyCodable].self, from: jsonData)
        
        XCTAssertEqual(decoded.count, 3)
    }
    
    func testComponentContainerView() throws {
        let factory = AIDUIComponentFactory()
        
        // Register a simple test component
        factory.register(component: "text") { _ in
            AnyView(Text("Hello World"))
        }
        
        let data: [String: AnyCodable] = [
            "name": AnyCodable("text"),
            "arguments": AnyCodable([:])
        ]
        
        let containerView = AIDUIComponentContainerView(data, factory: factory)
        
        // This test just verifies the view can be created without crashing
        XCTAssertNotNil(containerView)
    }
}

// MARK: - Test Component Examples

    struct TestComponentScheme: AIDUIComponentScheme {
    let title: String
    let color: String?
    
    init(title: String, color: String? = nil) {
        self.title = title
        self.color = color
    }
}

    struct TestComponent: AIDUIComponentView {
    typealias Scheme = TestComponentScheme
    
    let scheme: TestComponentScheme
    
    init(scheme: TestComponentScheme) {
        self.scheme = scheme
    }
    
    var body: some View {
        Text(scheme.title)
            .foregroundColor(scheme.color.flatMap { colorName in
                switch colorName.lowercased() {
                case "red": return .red
                case "blue": return .blue
                case "green": return .green
                default: return nil
                }
            } ?? .primary)
    }
}

final class ComponentViewTests: XCTestCase {
    
    func testAIDUIComponentViewProtocol() throws {
        let factory = AIDUIComponentFactory()
        
        // Test registering a component view type
        factory.register(TestComponent.self, as: "test_component")
        
        XCTAssertTrue(factory.isRegistered(component: "test_component"))
        
        // Test creating component data
        let testScheme = TestComponentScheme(title: "Hello", color: "blue")
        let component = AIDUIComponent(name: "test_component", arguments: testScheme)
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(component)
        
        // Verify the data can be decoded back
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode(AIDUIComponent<TestComponentScheme>.self, from: data)
        
        XCTAssertEqual(decoded.name, "test_component")
        XCTAssertEqual(decoded.arguments.title, "Hello")
        XCTAssertEqual(decoded.arguments.color, "blue")
    }
} 