//
//  ProgressCalculator.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 18/01/2025.
//

import SwiftUI

class ProgressCalculator {
    /// Calculates the progress percentage for a given goal
    /// - Parameters:
    ///   - goal: The goal for which progress is being calculated
    ///   - completedDates: List of dates on which the goal was marked as completed
    /// - Returns: A value between 0 and 100 representing the percentage of progress
    static func calculateProgress(for goal: Goal, completedDates: [Date]) -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Current day normalized
        let deadline = calendar.startOfDay(for: goal.normalizedDeadline) // Goal deadline normalized

        guard today <= deadline else { return 100.0 } // If overdue, cap progress at 100%

        // Calculate the total number of days from today to the deadline
        let totalDays = calendar.dateComponents([.day], from: today, to: deadline).day ?? 0

        // Calculate the total number of required completions
        let totalCompletions = Int(goal.metric.value) * max(totalDays, 1) // Ensure at least one day

        // Progress per single completion
        let progressPerCompletion = 100.0 / Double(totalCompletions)

        // Total progress based on completed dates
        let totalCompletionsLogged = completedDates.count
        let progress = Double(totalCompletionsLogged) * progressPerCompletion

        return min(progress, 100.0) // Cap progress at 100% to avoid overflow
    }
}
