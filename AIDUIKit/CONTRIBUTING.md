# Contributing to AIDUIKit

Thank you for your interest in contributing to AIDUIKit! This document provides guidelines and information for contributors.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/yourusername/AIDUIKit.git
cd AIDUIKit
   ```
3. **Create a new branch** for your feature or fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 🏗️ Development Setup

### Prerequisites
- Xcode 15.0+
- Swift 5.10+
- macOS 13.0+ (for development)

### Building and Testing
```bash
# Build the package
swift build

# Run tests
swift test

# Run tests with coverage
swift test --enable-code-coverage

# Generate documentation (if you have DocC)
swift package generate-documentation
```

## 📝 Contribution Guidelines

### Code Style
- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Keep functions focused and concise
- Use `// MARK:` to organize code sections

### Example:
```swift
/// Creates a new component factory with the specified configuration
/// - Parameters:
///   - decoder: JSON decoder for parsing component data
///   - componentBuilders: Initial set of component builders
/// - Returns: A configured MimeticComponentFactory instance
public init(
    decoder: JSONDecoder = JSONDecoder(),
    componentBuilders: [String: ComponentBuilder] = [:]
) {
    self.decoder = decoder
    self.componentBuilders = componentBuilders
}
```

### Testing
- **Write tests** for all new functionality
- **Maintain 90%+ code coverage**
- **Test on multiple platforms** (iOS, macOS, tvOS, watchOS)
- **Include edge cases** and error scenarios

Example test structure:
```swift
func testComponentRegistration() throws {
    let factory = MimeticComponentFactory()
    
    // Test registration
    factory.register(TestComponent.self, as: "test")
    XCTAssertTrue(factory.isRegistered(component: "test"))
    
    // Test component creation
    let data = createTestData()
    let view = factory.makeView(from: data)
    XCTAssertNotNil(view)
}
```

### Documentation
- Add comprehensive documentation for public APIs
- Update README.md if adding significant features
- Include code examples in documentation
- Update CHANGELOG.md for notable changes

## 🎯 Types of Contributions

### 🐛 Bug Fixes
- Include a clear description of the bug
- Add tests that reproduce the issue
- Ensure the fix doesn't break existing functionality

### ✨ New Features
- **Discuss first**: Open an issue to discuss new features before implementing
- Follow existing patterns and conventions
- Add comprehensive tests
- Update documentation and examples

### 🧪 New Component Examples
We welcome new example components! Follow this pattern:

```swift
// 1. Define the scheme
public struct YourComponentScheme: MimeticComponentScheme {
    public let property1: String
    public let property2: Int?
    
    public init(property1: String, property2: Int? = nil) {
        self.property1 = property1
        self.property2 = property2
    }
}

// 2. Create the component
public struct YourComponent: MimeticComponentView {
    public typealias Scheme = YourComponentScheme
    
    public let scheme: YourComponentScheme
    
    public init(scheme: YourComponentScheme) {
        self.scheme = scheme
    }
    
    public var body: some View {
        // Your implementation
    }
}

// 3. Add registration helper
public extension MimeticComponentFactory {
    func registerYourComponent() {
        register(YourComponent.self, as: "your_component")
    }
}

// 4. Add example data
public extension ExampleData {
    static let yourComponentExample: [String: AnyCodable] = [
        "name": AnyCodable("your_component"),
        "arguments": AnyCodable([
            "property1": AnyCodable("example"),
            "property2": AnyCodable(42)
        ])
    ]
}
```

### 📚 Documentation Improvements
- Fix typos or unclear explanations
- Add more examples
- Improve API documentation
- Update setup instructions

## 🔄 Pull Request Process

1. **Update your branch** with the latest main:
   ```bash
   git checkout main
   git pull upstream main
   git checkout your-branch
   git rebase main
   ```

2. **Run all tests** and ensure they pass:
   ```bash
   swift test
   ```

3. **Check your changes**:
   - Code builds without warnings
   - Tests pass on all platforms
   - Documentation is updated
   - CHANGELOG.md is updated (for notable changes)

4. **Create a pull request** with:
   - Clear title and description
   - Reference any related issues
   - Screenshots/GIFs for UI changes
   - Breaking changes clearly marked

5. **Respond to feedback** promptly and make requested changes

## 🎨 Component Design Principles

When creating new components, follow these principles:

### ✅ Do:
- Keep components focused on a single responsibility
- Make properties optional when reasonable
- Use semantic naming for properties
- Support accessibility features
- Handle edge cases gracefully
- Follow SwiftUI conventions

### ❌ Don't:
- Create overly complex components
- Use platform-specific APIs without fallbacks
- Hardcode values that should be configurable
- Ignore accessibility
- Break existing API contracts

## 🆘 Getting Help

- **Questions**: Open a GitHub Discussion
- **Bugs**: Open a GitHub Issue
- **Features**: Open a GitHub Issue with the "enhancement" label

## 📋 Issue Templates

When reporting bugs, please include:
- AIDUIKit version
- iOS/macOS version
- Xcode version
- Steps to reproduce
- Expected vs actual behavior
- Sample code (if applicable)

## 🏷️ Versioning

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to AIDUIKit! 🎉 