//  DeadlineCalculator.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 18/01/2025.

import SwiftUI

class DeadlineCalculator {
    /// Calculates the deadline based on the selected option and input parameters
    /// - Parameters:
    ///   - option: The selected deadline option (e.g., "End of the Year", "Custom Date")
    ///   - customDate: A user-provided custom date, if applicable
    ///   - months: Number of custom months to add, if applicable
    ///   - days: Number of custom days to add, if applicable
    ///   - weeks: Number of custom weeks to add, if applicable
    /// - Returns: A `Date` object representing the calculated deadline
    static func calculateDeadline(option: String, customDate: Date?, months: Int?, days: Int?, weeks: Int?) -> Date {
        let calendar = Calendar.current
        switch option {
        case "End of the Year":
            // Returns December 31 of the current year
            return calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: 12, day: 31)) ?? Date()
        case "Custom Date":
            // Returns the custom date provided by the user
            return customDate ?? Date()
        case "Custom Months":
            // Adds the specified number of months to the current date
            return calendar.date(byAdding: .month, value: months ?? 1, to: Date()) ?? Date()
        case "Custom Days":
            // Adds the specified number of days to the current date
            return calendar.date(byAdding: .day, value: days ?? 1, to: Date()) ?? Date()
        case "Custom Weeks":
            // Adds the specified number of weeks to the current date
            return calendar.date(byAdding: .day, value: (weeks ?? 1) * 7, to: Date()) ?? Date()
        default:
            return Date()
        }
    }
}
