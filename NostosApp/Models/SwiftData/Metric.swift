//
//  Metric.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import Foundation
import SwiftData

@Model
class Metric {
    var label: String // Description of the metric (e.g., "Hours per Week")
    var value: Double // Target value for the metric (e.g., 2.0 for "2 hours")
    var unit: String // Measurement unit for the metric (e.g., "hours", "sessions")
    var period: String? // Tracking period (e.g., "day", "week", "month")
    var isCustom: Bool // Indicates if the metric is user-defined

    // Initializes a metric with specific properties
    init(label: String, value: Double, unit: String, period: String?, isCustom: Bool) {
        self.label = label
        self.value = value
        self.unit = unit
        self.period = period
        self.isCustom = isCustom
    }
}

extension Metric {
    // Calculates the total number of expected completions until the given deadline
    func calculateTotalChecks(until deadline: Date) -> Int {
        let calendar = Calendar.current
        switch period {
        case "day":
            // Number of days between now and the deadline
            return calendar.dateComponents([.day], from: Date(), to: deadline).day ?? 0
        case "week":
            // Number of weeks between now and the deadline
            return (calendar.dateComponents([.day], from: Date(), to: deadline).day ?? 0) / 7
        case "month":
            // Number of months between now and the deadline
            return calendar.dateComponents([.month], from: Date(), to: deadline).month ?? 0
        default:
            return 0 
        }
    }
}
