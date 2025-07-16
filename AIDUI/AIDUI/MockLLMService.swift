//
//  MockLLMService.swift
//  AIDUI
//
//  Created by Patricio Reyes on 7/15/25.
//

import Foundation

struct MockLLMService {
    
    func requestChart(prompt: String) async -> Data {
        // Simulate API delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second
        
        let responseJSON: String
        
        switch prompt {
        case "Show my heart rate data with a clean blue theme":
            responseJSON = cleanBlueHeartRateChart()
            
        case "Show my sleep quality with a dark mode theme":
            responseJSON = darkModeSleepChart()
            
        case "Show my workout intensity with vibrant green colors":
            responseJSON = vibrantGreenWorkoutChart()
            
        case "Show my step count with minimal gray styling":
            responseJSON = minimalGrayStepsChart()
            
        case "Show my calories burned with warm orange theme":
            responseJSON = warmOrangeCaloriesChart()
            
        case "Show my blood pressure with professional navy styling":
            responseJSON = professionalNavyBloodPressureChart()
            
        default:
            responseJSON = cleanBlueHeartRateChart()
        }
        
        return responseJSON.data(using: .utf8) ?? Data()
    }
    
    private func cleanBlueHeartRateChart() -> String {
        return """
        {
            "name": "line_chart",
            "arguments": {
                "title": "Heart Rate",
                "data": [
                    {"xValue": "Mon", "yValue": 72},
                    {"xValue": "Tue", "yValue": 75},
                    {"xValue": "Wed", "yValue": 68},
                    {"xValue": "Thu", "yValue": 82},
                    {"xValue": "Fri", "yValue": 78},
                    {"xValue": "Sat", "yValue": 65},
                    {"xValue": "Sun", "yValue": 70}
                ],
                "style": {
                    "primaryColor": "#007AFF",
                    "backgroundColor": "#F8F9FA",
                    "titleFontSize": 20,
                    "titleColor": "#1D1D1F",
                    "lineWidth": 3,
                    "showGrid": true,
                    "cornerRadius": 12
                }
            }
        }
        """
    }
    
    private func darkModeSleepChart() -> String {
        return """
        {
            "name": "line_chart",
            "arguments": {
                "title": "Sleep Quality Score",
                "data": [
                    {"xValue": "Mon", "yValue": 85},
                    {"xValue": "Tue", "yValue": 78},
                    {"xValue": "Wed", "yValue": 92},
                    {"xValue": "Thu", "yValue": 88},
                    {"xValue": "Fri", "yValue": 75},
                    {"xValue": "Sat", "yValue": 95},
                    {"xValue": "Sun", "yValue": 90}
                ],
                "style": {
                    "primaryColor": "#64D2FF",
                    "backgroundColor": "#1C1C1E",
                    "titleFontSize": 18,
                    "titleColor": "#FFFFFF",
                    "lineWidth": 2.5,
                    "showGrid": true,
                    "cornerRadius": 8
                }
            }
        }
        """
    }
    
    private func vibrantGreenWorkoutChart() -> String {
        return """
        {
            "name": "line_chart",
            "arguments": {
                "title": "Workout Intensity",
                "data": [
                    {"xValue": "Week 1", "yValue": 65},
                    {"xValue": "Week 2", "yValue": 72},
                    {"xValue": "Week 3", "yValue": 85},
                    {"xValue": "Week 4", "yValue": 78},
                    {"xValue": "Week 5", "yValue": 92},
                    {"xValue": "Week 6", "yValue": 88},
                    {"xValue": "Week 7", "yValue": 95}
                ],
                "style": {
                    "primaryColor": "#30D158",
                    "backgroundColor": "#F0FFF4",
                    "titleFontSize": 22,
                    "titleColor": "#006400",
                    "lineWidth": 4,
                    "showGrid": true,
                    "cornerRadius": 16
                }
            }
        }
        """
    }
    
    private func minimalGrayStepsChart() -> String {
        return """
        {
            "name": "line_chart",
            "arguments": {
                "title": "Daily Steps",
                "data": [
                    {"xValue": "Mon", "yValue": 8500},
                    {"xValue": "Tue", "yValue": 12000},
                    {"xValue": "Wed", "yValue": 9500},
                    {"xValue": "Thu", "yValue": 11200},
                    {"xValue": "Fri", "yValue": 7800},
                    {"xValue": "Sat", "yValue": 15000},
                    {"xValue": "Sun", "yValue": 13500}
                ],
                "style": {
                    "primaryColor": "#8E8E93",
                    "backgroundColor": "#FFFFFF",
                    "titleFontSize": 16,
                    "titleColor": "#3A3A3C",
                    "lineWidth": 2,
                    "showGrid": false,
                    "cornerRadius": 4
                }
            }
        }
        """
    }
    
    private func warmOrangeCaloriesChart() -> String {
        return """
        {
            "name": "line_chart",
            "arguments": {
                "title": "Calories Burned",
                "data": [
                    {"xValue": "6AM", "yValue": 45},
                    {"xValue": "9AM", "yValue": 120},
                    {"xValue": "12PM", "yValue": 85},
                    {"xValue": "3PM", "yValue": 200},
                    {"xValue": "6PM", "yValue": 350},
                    {"xValue": "9PM", "yValue": 180},
                    {"xValue": "12AM", "yValue": 60}
                ],
                "style": {
                    "primaryColor": "#FF9500",
                    "backgroundColor": "#FFF8F0",
                    "titleFontSize": 19,
                    "titleColor": "#CC7A00",
                    "lineWidth": 3.5,
                    "showGrid": true,
                    "cornerRadius": 10
                }
            }
        }
        """
    }
    
    private func professionalNavyBloodPressureChart() -> String {
        return """
        {
            "name": "line_chart",
            "arguments": {
                "title": "Systolic Blood Pressure",
                "data": [
                    {"xValue": "Jan", "yValue": 118},
                    {"xValue": "Feb", "yValue": 122},
                    {"xValue": "Mar", "yValue": 115},
                    {"xValue": "Apr", "yValue": 125},
                    {"xValue": "May", "yValue": 120},
                    {"xValue": "Jun", "yValue": 116},
                    {"xValue": "Jul", "yValue": 119}
                ],
                "style": {
                    "primaryColor": "#1E3A8A",
                    "backgroundColor": "#F1F5F9",
                    "titleFontSize": 17,
                    "titleColor": "#0F172A",
                    "lineWidth": 2.8,
                    "showGrid": true,
                    "cornerRadius": 6
                }
            }
        }
        """
    }
} 