//
//  AddGoalView.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct AddGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var currentStep: Int = 0

    @State private var title: String = ""
    @State private var selectedCategory: Category = .personalGrowth
    @State private var selectedType: GoalType = .timeBased
    @State private var metricValue: Double = 1.0
    @State private var selectedUnit: String = "hours"
    @State private var selectedPeriod: String = "day"
    @State private var deadlineOption: String = "End of the Year"
    @State private var customDeadline: Date = Date()

    var body: some View {
        VStack {
            if currentStep == 0 {
                StepGoalNameView(title: $title, onNext: goToNextStep)
            } else if currentStep == 1 {
                StepGoalCategoryView(
                    selectedCategory: $selectedCategory,
                    onNext: goToNextStep,
                    onBack: goToPreviousStep
                )
            } else if currentStep == 2 {
                StepGoalTypeView(
                    selectedType: $selectedType,
                    metricValue: $metricValue,
                    selectedUnit: $selectedUnit,
                    selectedPeriod: $selectedPeriod,
                    onNext: goToNextStep,
                    onBack: goToPreviousStep
                )
            } else if currentStep == 3 {
                StepGoalDeadlineView(
                    deadlineOption: $deadlineOption,
                    customDeadline: $customDeadline,
                    onBack: goToPreviousStep,
                    onSaveAndReset: saveGoalAndReset
                )
            }
        }
        .navigationTitle("Add Goal")
        .animation(.easeInOut, value: currentStep)
    }

    private func goToNextStep() {
        currentStep += 1
    }

    private func goToPreviousStep() {
        currentStep = max(currentStep - 1, 0)
    }

    // Save and reset
    private func saveGoalAndReset() {
        let metric =  Metric(
            label: "\(selectedUnit.capitalized) per \(selectedPeriod.capitalized)",
            value: metricValue,
            unit: selectedUnit,
            period: selectedPeriod,
            isCustom: false
        )

        let newGoal = Goal(
            title: title,
            type: selectedType,
            metric: metric,
            deadline: getFinalDeadline(),
            progress: 0.0,
            category: selectedCategory
        )

        viewModel.addGoal(newGoal)

        resetAllFields()
    }

    private func getFinalDeadline() -> Date {
        let calendar = Calendar.current
        switch deadlineOption {
        case "End of the Year":
            return calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: 12, day: 31)) ?? Date()
        case "1 Month":
            return calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        case "3 Months":
            return calendar.date(byAdding: .month, value: 3, to: Date()) ?? Date()
        case "Custom Date":
            return customDeadline
        default:
            return Date()
        }
    }

    private func resetAllFields() {
        title = ""
        selectedCategory = .personalGrowth
        selectedType = .timeBased
        metricValue = 1.0
        selectedUnit = "hours"
        selectedPeriod = "day"
        deadlineOption = "End of the Year"
        customDeadline = Date()
        currentStep = 0
    }
}
