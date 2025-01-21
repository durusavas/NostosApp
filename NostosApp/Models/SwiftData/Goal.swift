//
//  Goal.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import Foundation
import SwiftData
import SwiftUI

// Represents the type of goal: time-based or consistency-based
enum GoalType: String, Codable, CaseIterable {
    case timeBased        // Goals measured by time, e.g., hours of study
    case consistencyBased // Goals based on repeated actions, e.g., gym sessions
}

@Model
class Goal {
    var id: UUID // Unique identifier for each goal
    var title: String // Name or description of the goal
    var type: GoalType // Determines if the goal is time-based or consistency-based
    var metric: Metric // Associated metric defining progress requirements
    var normalizedDeadline: Date // Deadline normalized for tracking purposes
    var completedDates: [Date] // Tracks when goals are completed
    var category: Category // Category the goal belongs to (e.g., fitness, personal growth)
    var totalChecks: Int // Precomputed total expected completions for the goal

    // Dynamic progress calculation using `ProgressCalculator`
    var progress: Double {
        ProgressCalculator.calculateProgress(for: self, completedDates: completedDates)
    }

    // Initializer to set up a goal
    init(
        id: UUID = UUID(),
        title: String,
        type: GoalType,
        metric: Metric,
        normalizedDeadline: Date,
        completedDates: [Date] = [],
        category: Category
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.metric = metric
        self.normalizedDeadline = normalizedDeadline
        self.completedDates = completedDates
        self.category = category
        self.totalChecks = metric.calculateTotalChecks(until: normalizedDeadline) // Calculate expected completions
    }
}
