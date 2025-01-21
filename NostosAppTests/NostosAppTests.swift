//
//  NostosAppTests.swift
//  NostosAppTests
//
//  Created by Duru SAVAŞ on 20/01/2025.
//

import XCTest
@testable import NostosApp

final class NostosAppTests: XCTestCase {

    // MARK: - DeadlineCalculator Tests

    func testCustomPickerDeadline() {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let expected = calendar.date(byAdding: .day, value: 15 + (2 * 7), to: calendar.date(byAdding: .month, value: 1, to: now) ?? now) ?? now

        let deadline = DeadlineCalculator.calculateDeadline(
            option: "Custom Picker",
            customDate: nil,
            months: 1,
            days: 15,
            weeks: 2
        )

        XCTAssertEqual(
            deadline,
            expected,
            "Custom Picker deadline calculation is incorrect."
        )
    }


    func testCustomDateDeadline() {
        let customDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())!
        let normalizedDate = Calendar.current.startOfDay(for: customDate)

        let deadline = DeadlineCalculator.calculateDeadline(
            option: "Custom Date",
            customDate: customDate,
            months: nil,
            days: nil,
            weeks: nil
        )

        XCTAssertEqual(
            deadline,
            normalizedDate,
            "Custom Date deadline calculation is incorrect."
        )
    }


    func testEndOfYearDeadline() {
        let calendar = Calendar.current
        let now = Date()
        let year = calendar.component(.year, from: now)
        let expected = calendar.date(from: DateComponents(year: year, month: 12, day: 31))!

        let deadline = DeadlineCalculator.calculateDeadline(
            option: "End of the Year",
            customDate: nil,
            months: nil,
            days: nil,
            weeks: nil
        )

        XCTAssertEqual(
            deadline,
            expected,
            "End of the Year deadline calculation is incorrect."
        )
    }

    // MARK: - GoalViewModel Progress Tests

    func testProgressForDailyGoal() {
        let viewModel = GoalViewModel()
        let goal = Goal(
            title: "Daily Task",
            type: .consistencyBased,
            metric: Metric(label: "1 Time per Day", value: 1.0, unit: "times", period: "day", isCustom: false),
            normalizedDeadline: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            completedDates: [],
            category: .lifestyle
        )
        viewModel.completions[goal.id] = 1
        let progress = viewModel.calculateProgress(for: goal)
        XCTAssertEqual(progress, 14.29, accuracy: 0.01, "Progress for daily goal is incorrect.")
    }

    func testProgressForWeeklyGoal() {
        let viewModel = GoalViewModel()
        let goal = Goal(
            title: "Weekly Task",
            type: .timeBased,
            metric: Metric(label: "1 Time per Week", value: 1.0, unit: "times", period: "week", isCustom: false),
            normalizedDeadline: Calendar.current.date(byAdding: .weekOfYear, value: 4, to: Date())!,
            completedDates: [],
            category: .educational
        )
        viewModel.completions[goal.id] = 1
        let progress = viewModel.calculateProgress(for: goal)
        XCTAssertEqual(progress, 25.0, "Progress for weekly goal is incorrect.")
    }

    func testProgressForMonthlyGoal() {
        let viewModel = GoalViewModel()
        let goal = Goal(
            title: "Monthly Task",
            type: .timeBased,
            metric: Metric(label: "2 Times per Month", value: 2.0, unit: "times", period: "month", isCustom: false),
            normalizedDeadline: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
            completedDates: [],
            category: .personalGrowth
        )
        viewModel.completions[goal.id] = 1
        let progress = viewModel.calculateProgress(for: goal)
        XCTAssertEqual(progress, 50.0, "Progress for monthly goal is incorrect.")
    }

    // MARK: - Complex Scenario Tests

    func testComplexProgressScenario() {
        let viewModel = GoalViewModel()
        let goal = Goal(
            title: "Custom Goal",
            type: .timeBased,
            metric: Metric(label: "3 Times per Week", value: 3.0, unit: "times", period: "week", isCustom: false),
            normalizedDeadline: Calendar.current.date(byAdding: .weekOfYear, value: 2, to: Date())!,
            completedDates: [],
            category: .lifestyle
        )
        viewModel.completions[goal.id] = 3
        let progress = viewModel.calculateProgress(for: goal)
        XCTAssertEqual(progress, 50.0, "Progress for a 2-week goal with custom completions is incorrect.")
    }
}
