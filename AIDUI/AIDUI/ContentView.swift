//
//  ContentView.swift
//  AIDUI
//
//  Created by Patricio Reyes on 7/15/25.
//

import SwiftUI
import AIDUIKit

enum DemoPrompt: String, CaseIterable {
    case cleanBlue = "Show my heart rate data with a clean blue theme"
    case darkMode = "Show my sleep quality with a dark mode theme"
    case vibrantGreen = "Show my workout intensity with vibrant green colors"
    case minimalGray = "Show my step count with minimal gray styling"
    case warmOrange = "Show my calories burned with warm orange theme"
    case professionalNavy = "Show my blood pressure with professional navy styling"
}

struct ContentView: View {
    private let llmService = MockLLMService()
    @State private var selectedPromptIndex = 0
    @State private var isLoading = false
    @State private var currentResponseData: Data?
    
    private var currentPrompt: DemoPrompt {
        DemoPrompt.allCases[selectedPromptIndex % DemoPrompt.allCases.count]
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("AI-Driven Chart Styling")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text(currentPrompt.rawValue)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let responseData = currentResponseData {
                AIDUIComponentContainerView(
                    jsonData: responseData,
                    factory: AIDUIComponentFactory.custom,
                    errorView: {
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.orange)
                            Text("Failed to load component")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                )
                .frame(maxHeight: .infinity)
            } else if isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else {
                Spacer()
            }
            
            HStack {
                Button("Previous") {
                    if !isLoading {
                        previousExample()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(isLoading)
                
                Spacer()
                
                Text("\(selectedPromptIndex + 1) of \(DemoPrompt.allCases.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Next") {
                    if !isLoading {
                        nextExample()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
        .onAppear {
            generateCurrent()
        }
    }
    
    private func nextExample() {
        selectedPromptIndex = (selectedPromptIndex + 1) % DemoPrompt.allCases.count
        generateCurrent()
    }
    
    private func previousExample() {
        selectedPromptIndex = selectedPromptIndex == 0 ? DemoPrompt.allCases.count - 1 : selectedPromptIndex - 1
        generateCurrent()
    }
    
    private func generateCurrent() {
        Task {
            isLoading = true
            currentResponseData = await llmService.requestChart(prompt: currentPrompt.rawValue)
            isLoading = false
        }
    }
}

#Preview {
    ContentView()
}
