//
//  Metric.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import Foundation
import SwiftData

@Model
class Metric{
    var label: String          // Description (e.g., "Hours per Week", "Times per Day")
    var value: Double          // Numeric target (e.g., 2.0 for "2 hours")
    var unit: String           // Measurement unit (e.g., "hours", "sessions")
    var period: String?        // Period for tracking (e.g., "day", "week", "month")
    var isCustom: Bool         // True for user-defined metrics
    
    init(label: String, value: Double, unit: String, period: String?, isCustom: Bool) {
        self.label = label
        self.value = value
        self.unit = unit
        self.period = period
        self.isCustom = isCustom
    }
    
}
