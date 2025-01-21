//
//  GoalViewModel.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import Foundation
import SwiftData

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var completions: [UUID: Int] = [:] // Tracks completions for the current timeframe
    @Published var checkIns: [UUID: [Date]] = [:] // Tracks check-in dates per goal

    private let calendar = Calendar.current

//    init() {
//        addDemoData() // Initialize with sample data for testing
//    }

    private func addDemoData() {
        let calendar = Calendar.current
        let today = Date()

        let goals = [
            Goal(
                title: "Master the Art of Procrastination",
                type: .timeBased,
                metric: Metric(label: "Hours per Day", value: 3.0, unit: "hours", period: "day", isCustom: false),
                normalizedDeadline: calendar.date(byAdding: .day, value:2 , to: today) ?? today,
                completedDates: [calendar.date(byAdding: .day, value: -1, to: today)!],
                category: .personalGrowth
            ),
            Goal(
                title: "Eat All the Snacks Before Dinner",
                type: .consistencyBased,
                metric: Metric(label: "Snacks per Day", value: 5.0, unit: "snacks", period: "day", isCustom: true),
                normalizedDeadline: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                completedDates: [today],
                category: .lifestyle
            ),
            Goal(
                title: "Finally Understand What Blockchain Is",
                type: .timeBased,
                metric: Metric(label: "Articles per Month", value: 2.0, unit: "articles", period: "month", isCustom: false),
                normalizedDeadline: calendar.date(byAdding: .month, value: 1, to: today) ?? today,
                completedDates: [],
                category: .educational
            ),
            Goal(
                title: "Turn Off Notifications for Once",
                type: .consistencyBased,
                metric: Metric(label: "Days per Week", value: 1.0, unit: "day", period: "week", isCustom: false),
                normalizedDeadline: calendar.date(byAdding: .weekOfYear, value: 1, to: today) ?? today,
                completedDates: [],
                category: .lifestyle
            ),
            Goal(
                title: "Convince a Cat to Love You",
                type: .timeBased,
                metric: Metric(label: "Hours per Day", value: 2.0, unit: "hours", period: "day", isCustom: false),
                normalizedDeadline: calendar.date(byAdding: .day, value: 5, to: today) ?? today,
                completedDates: [calendar.date(byAdding: .day, value: -2, to: today)!],
                category: .personalGrowth
            ),
            Goal(
                title: "Find a Pen That Actually Writes",
                type: .timeBased,
                metric: Metric(label: "Stores per Week", value: 3.0, unit: "stores", period: "week", isCustom: true),
                normalizedDeadline: calendar.date(byAdding: .weekOfYear, value: 1, to: today) ?? today,
                completedDates: [],
                category: .lifestyle
            ),
            Goal(
                title: "Discover the Secrets of the Universe (via YouTube)",
                type: .timeBased,
                metric: Metric(label: "Videos per Day", value: 10.0, unit: "videos", period: "day", isCustom: false),
                normalizedDeadline: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                completedDates: [calendar.date(byAdding: .day, value: -1, to: today)!, today],
                category: .educational
            ),
            Goal(
                title: "Take a Walk Without Checking Your Phone",
                type: .consistencyBased,
                metric: Metric(label: "Walks per Week", value: 2.0, unit: "walks", period: "week", isCustom: false),
                normalizedDeadline: calendar.date(byAdding: .weekOfYear, value: 1, to: today) ?? today,
                completedDates: [calendar.date(byAdding: .day, value: -1, to: today)!],
                category: .lifestyle
            ),
            Goal(
                title: "Watch a Movie Without Googling the Cast",
                type: .timeBased,
                metric: Metric(label: "Movies per Week", value: 1.0, unit: "movie", period: "week", isCustom: false),
                normalizedDeadline: calendar.date(byAdding: .weekOfYear, value: 1, to: today) ?? today,
                completedDates: [],
                category: .personalGrowth
            ),
            Goal(
                title: "Learn What All the Buttons on the Microwave Do",
                type: .timeBased,
                metric: Metric(label: "Buttons per Month", value: 4.0, unit: "buttons", period: "month", isCustom: false),
                normalizedDeadline: calendar.date(byAdding: .month, value: 1, to: today) ?? today,
                completedDates: [],
                category: .educational
            )
        ]

        self.goals.append(contentsOf: goals)
        print("Added 10 sarcastic demo goals: \(goals.map { $0.title })") // Log demo goals
    }


    func addGoal(
        title: String,
        type: GoalType,
        metric: Metric,
        deadline: Date,
        category: Category
    ) {
        let newGoal = Goal(
            title: title,
            type: type,
            metric: metric,
            normalizedDeadline: deadline,
            category: category
        )
        goals.append(newGoal)
    }

    func logCheck(for goal: Goal) {
        // Updates the completion count and records the date for a goal check-in
        let currentCompletions = completions[goal.id] ?? 0
        if currentCompletions < Int(goal.metric.value) {
            completions[goal.id] = currentCompletions + 1
            if checkIns[goal.id] == nil {
                checkIns[goal.id] = []
            }

            // Add the current date, ensuring it's stored as the start of the day
            let currentDate = Calendar.current.startOfDay(for: Date())
            checkIns[goal.id]?.append(currentDate)

            // Update the goal's completedDates property
            if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                goals[index].completedDates.append(currentDate)
            }
        } else {
            print("Maximum completions reached for the current timeframe.")
        }
    }

    // Check Completion Status
    func isCompleted(for goal: Goal) -> Bool {
        // Determines if a goal is fully completed for the current period
        let currentCompletions = completions[goal.id] ?? 0
        return currentCompletions >= Int(goal.metric.value)
    }

    func resetCompletionsIfNeeded() {
        for goal in goals {
            // Resets the completion count if the goal's period has elapsed
            if shouldResetCompletions(for: goal) {
                completions[goal.id] = 0
            }
        }
    }

    private func shouldResetCompletions(for goal: Goal) -> Bool {
        // Checks if the completions for a goal should reset based on its tracking period
        let lastReset = getLastResetDate(for: goal)
        let now = Date()

        switch goal.metric.period {
        case "day":
            return !calendar.isDateInToday(lastReset)
        case "week":
            guard let currentWeekInterval = calendar.dateInterval(of: .weekOfYear, for: now),
                  let lastWeekInterval = calendar.dateInterval(of: .weekOfYear, for: lastReset) else {
                return false
            }
            return currentWeekInterval.start != lastWeekInterval.start
        case "month":
            return !calendar.isDate(lastReset, equalTo: now, toGranularity: .month)
        default:
            return false
        }
    }

    private func getLastResetDate(for goal: Goal) -> Date {
        return checkIns[goal.id]?.last ?? Date()
    }

    // MARK: - Calculate Progress
    func calculateProgress(for goal: Goal) -> Double {
        // Calculates the progress percentage for a given goal
        let completedDates = checkIns[goal.id] ?? []
        return ProgressCalculator.calculateProgress(for: goal, completedDates: completedDates)
    }

    // MARK: - Filter Goals by Timeframe
    func filterGoals(by period: String) -> [Goal] {
        // Filters the goals based on their tracking period (e.g., "day", "week", "month")
        return goals.filter { $0.metric.period == period }
    }

    // MARK: - Calculate Overall Progress
    func calculateOverallProgress(for goals: [Goal]) -> Double {
        // Computes the average progress across all goals in the given list
        guard !goals.isEmpty else { return 0.0 }

        var totalProgress: Double = 0.0
        for goal in goals {
            totalProgress += calculateProgress(for: goal)
        }

        return totalProgress / Double(goals.count)
    }
}
