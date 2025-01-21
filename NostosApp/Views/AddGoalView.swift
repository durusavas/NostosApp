//
//  AddGoalView.swift
//  NostosApp
//

import SwiftUI

struct AddGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var currentStep: Int = 0
    
    // Goal Properties
    @State private var title: String = ""
    @State private var selectedCategory: Category = .personalGrowth
    @State private var selectedType: GoalType = .timeBased
    @State private var metricValue: Double = 1.0
    @State private var selectedUnit: String = NSLocalizedString("days", comment: "Unit for time-based goals")
    @State private var selectedPeriod: String = NSLocalizedString("day", comment: "Time period for tracking")
    
    // Custom Deadline Options
    @State private var deadline: Date = Date()
    @State private var deadlineOption: String = NSLocalizedString("End of the Year", comment: "Deadline option")
    @State private var customDeadline: Date = Date()

    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
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
                        deadline: $deadline,
                        deadlineOption: $deadlineOption,
                        customDeadline: $customDeadline,
                        onBack: goToPreviousStep,
                        onSaveAndReset: saveGoalAndReset
                    )
                }
            }
            .animation(.easeInOut, value: currentStep)
        }
    }
    
    // MARK: - Navigation Methods
    private func goToNextStep() {
        currentStep += 1
    }
    
    private func goToPreviousStep() {
        currentStep = max(currentStep - 1, 0)
    }
    
    // MARK: - Save Goal and Reset
    private func saveGoalAndReset(finalDeadline: Date) {
        // Create a new metric based on user input
        let metric = Metric(
            label: "\(selectedUnit.capitalized) \(NSLocalizedString("per", comment: "Per time period")) \(selectedPeriod.capitalized)",
            value: metricValue,
            unit: selectedUnit,
            period: selectedPeriod,
            isCustom: false
        )
        
        // Save the new goal to the ViewModel
        viewModel.addGoal(
            title: title,
            type: selectedType,
            metric: metric,
            deadline: finalDeadline,
            category: selectedCategory
        )
        resetAllFields()
    }
    
    private func resetAllFields() {
        // Reset all input fields to their default values
        title = ""
        selectedCategory = .personalGrowth
        selectedType = .timeBased
        metricValue = 1.0
        selectedUnit = NSLocalizedString("days", comment: "Default time unit")
        selectedPeriod = NSLocalizedString("day", comment: "Default time period")
        deadline = Date()
        deadlineOption = NSLocalizedString("End of the Year", comment: "Default deadline option")
        customDeadline = Date()
        currentStep = 0
    }
}

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        let demoViewModel = GoalViewModel()
        AddGoalView(viewModel: demoViewModel)
    }
}
