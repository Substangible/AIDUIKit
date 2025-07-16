# AIDUIKit

A powerful SwiftUI framework for creating dynamic, AI-driven user interfaces. AIDUIKit allows you to build components that can be serialized, transmitted, and rendered dynamically from JSON data.

## Features

- 🧩 **Dynamic Component System**: Create and register reusable UI components
- 📱 **SwiftUI Native**: Built specifically for SwiftUI with native performance
- 🔄 **JSON Serialization**: Components can be serialized to/from JSON
- 🎯 **Type Safety**: Strongly typed component schemes prevent runtime errors
- 🏗️ **Factory Pattern**: Centralized component creation and management
- 🧪 **Thoroughly Tested**: Comprehensive test coverage
- 🔧 **Zero Dependencies**: No external dependencies, includes custom AnyCodable implementation

## Installation

### Swift Package Manager

Add AIDUIKit to your project using Xcode or by adding it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/AIDUIKit.git", from: "1.0.0")
]
```

## Quick Start

### 1. Create a Component Scheme

```swift
import AIDUIKit

struct ButtonComponentScheme: AIDUIComponentScheme {
    let title: String
    let backgroundColor: String
    let action: String
}
```

### 2. Create a Component View

```swift
struct ButtonComponent: AIDUIComponentView {
    typealias Scheme = ButtonComponentScheme
    
    let scheme: ButtonComponentScheme
    
    init(scheme: ButtonComponentScheme) {
        self.scheme = scheme
    }
    
    var body: some View {
        Button(scheme.title) {
            // Handle action
            print("Action: \(scheme.action)")
        }
        .foregroundColor(.white)
        .padding()
        .background(Color(scheme.backgroundColor))
        .cornerRadius(8)
    }
}
```

### 3. Register and Use Components

```swift
import SwiftUI
import AIDUIKit

struct ContentView: View {
    @StateObject private var factory = AIDUIComponentFactory()
    
    var body: some View {
        VStack {
            // Render component from JSON
            AIDUIComponentContainerView(sampleData, factory: factory)
        }
        .onAppear {
            setupComponents()
        }
    }
    
    private func setupComponents() {
        // Register your components
        factory.register(ButtonComponent.self, as: "button")
    }
    
    private var sampleData: [String: AnyCodable] {
        [
            "name": AnyCodable("button"),
            "arguments": AnyCodable([
                "title": AnyCodable("Click Me"),
                "background_color": AnyCodable("blue"),
                "action": AnyCodable("submit")
            ])
        ]
    }
}
```

## Component Creation Patterns

### Simple Components

For components that don't need configuration:

```swift
struct LoaderComponent: MimeticComponentView {
    typealias Scheme = EmptyScheme
    
    init(scheme: EmptyScheme) {}
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    }
}
```

### Complex Components

For components with rich configuration:

```swift
struct ChartComponentScheme: MimeticComponentScheme {
    let data: [DataPoint]
    let title: String
    let showLegend: Bool
    let colors: [String]
    
    struct DataPoint: Codable, Hashable {
        let label: String
        let value: Double
    }
}

struct ChartComponent: MimeticComponentView {
    typealias Scheme = ChartComponentScheme
    
    let scheme: ChartComponentScheme
    
    init(scheme: ChartComponentScheme) {
        self.scheme = scheme
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(scheme.title)
                .font(.headline)
            
            // Your chart implementation here
            
            if scheme.showLegend {
                // Legend implementation
            }
        }
    }
}
```

## Factory Management

### Component Registration

```swift
let factory = MimeticComponentFactory()

// Register by type (uses type name)
factory.register(ButtonComponent.self)

// Register with custom name
factory.register(ButtonComponent.self, as: "custom_button")

// Register with manual builder
factory.register(component: "special_button") { data in
    // Custom component creation logic
    return AnyView(Text("Special Button"))
}
```

### Component Inspection

```swift
// Check what components are registered
print(factory.registeredComponents) // ["button", "chart", "loader"]

// Check if specific component exists
if factory.isRegistered(component: "button") {
    // Component is available
}

// Unregister components
factory.unregister(component: "button")
```

## JSON Data Format

Components expect JSON data in this format:

```json
{
  "name": "component_name",
  "arguments": {
    "property1": "value1",
    "property2": 42,
    "nested_object": {
      "key": "value"
    }
  }
}
```

### Working with JSON

```swift
// From JSON string
let jsonString = """
{
  "name": "button",
  "arguments": {
    "title": "Click Me",
    "background_color": "blue"
  }
}
"""

let containerView = try MimeticComponentContainerView(
    jsonString: jsonString,
    factory: factory
)

// From JSON Data
let jsonData = jsonString.data(using: .utf8)!
let containerView = try MimeticComponentContainerView(
    jsonData: jsonData,
    factory: factory
)
```

## Error Handling

AIDUIKit provides comprehensive error handling:

```swift
do {
    let view = try MimeticComponentContainerView(
        jsonString: invalidJSON,
        factory: factory
    )
} catch MimeticComponentError.invalidJSONString {
    print("Invalid JSON format")
} catch MimeticComponentError.decodingFailed(let error) {
    print("Failed to decode: \(error)")
} catch MimeticComponentError.componentNotFound(let name) {
    print("Component '\(name)' not found")
}
```

## Advanced Usage

### Custom JSON Decoding

```swift
let customDecoder = JSONDecoder()
customDecoder.keyDecodingStrategy = .convertFromSnakeCase
customDecoder.dateDecodingStrategy = .iso8601

let factory = MimeticComponentFactory(decoder: customDecoder)
```

### Dynamic Component Loading

```swift
class ComponentLoader {
    private let factory = MimeticComponentFactory()
    
    func loadComponents(from url: URL) async throws {
        let data = try await URLSession.shared.data(from: url).0
        let components = try JSONDecoder().decode([ComponentDefinition].self, from: data)
        
        for component in components {
            // Register components dynamically
            registerComponent(component)
        }
    }
}
```

## Best Practices

1. **Naming Convention**: Use snake_case for component names to match JSON conventions
2. **Scheme Design**: Keep schemes simple and focused on a single responsibility
3. **Error Handling**: Always handle potential JSON parsing errors gracefully
4. **Component Registration**: Register all components early in your app lifecycle
5. **Type Safety**: Leverage Swift's type system in your schemes for compile-time safety

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

AIDUIKit is available under the MIT license. See the LICENSE file for more info.

## Requirements

- iOS 16.0+ / macOS 13.0+ / tvOS 16.0+ / watchOS 9.0+
- Swift 5.10+
- Xcode 15.0+ 