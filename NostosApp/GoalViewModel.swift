//
//  GoalViewModel.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import Foundation
import SwiftData

class GoalViewModel: ObservableObject {
    
    // Published Properties
    @Published var goals: [Goal] = []
    @Published var dailyGoals: [Goal] = []
    @Published var weeklyGoals: [Goal] = []
    @Published var monthlyGoals: [Goal] = []
    
    @Published var checks: [UUID: Int] = [:]       // Tracks check counts per goal
    @Published var checkIns: [UUID: [Date]] = [:]  // Tracks check-in dates per goal

    // Filtering Goals by Timeframe for GoalsListView
    func filterGoalsByTimeframe() {
        dailyGoals = goals.filter { $0.metric.period == "day" }
        weeklyGoals = goals.filter { $0.metric.period == "week" }
        monthlyGoals = goals.filter { $0.metric.period == "month" }
    }

    // Calculating Progress for GoalProgressView
    func calculateProgress(for goal: Goal, checks: Int) -> Double {
        switch goal.type {
        case .timeBased:
            let metric = goal.metric
            let deadline = goal.deadline
            let totalDays = Date().daysUntil(to: deadline)
            let totalChecks = metric.value * Double(totalDays)
            let progressIncrement = 100 / totalChecks
            return Double(checks) * progressIncrement
        case .consistencyBased:
            let metric = goal.metric
            let totalSessions = metric.value
            let progressIncrement = 100 / totalSessions
            return Double(checks) * progressIncrement
       
        }
    }

    // Logging Check-Ins
    func logCheck(for goal: Goal) {
        
        let today = Calendar.current.startOfDay(for: Date())
        
        if let currentChecks = checks[goal.id], currentChecks > 0 {
        
            checks[goal.id] = 0
            goal.completedDates.removeAll { Calendar.current.isDate($0, inSameDayAs: today) }
        } else {
            checks[goal.id] = 1
            if !goal.completedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: today) }) {
                goal.completedDates.append(today)
            }
        }
    }


    // Overall Progress Calculation
    func calculateOverallProgress(for timeframeGoals: [Goal]) -> Double {
        guard !timeframeGoals.isEmpty else { return 0.0 }
        
        var overallProgress: Double = 0.0
        for goal in timeframeGoals {
            let checksForGoal = checks[goal.id] ?? 0
            overallProgress += calculateProgress(for: goal, checks: checksForGoal)
        }
        return overallProgress / Double(timeframeGoals.count)
    }

    // Adding New Goal
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        filterGoalsByTimeframe()
    }
}
