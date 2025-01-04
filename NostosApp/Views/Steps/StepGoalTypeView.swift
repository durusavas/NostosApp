//
//  StepGoalTypeView.swift
//  nostos
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct StepGoalTypeView: View {
    @Binding var selectedType: GoalType
    @Binding var metricValue: Double
    @Binding var selectedUnit: String
    @Binding var selectedPeriod: String
    let onNext: () -> Void
    let onBack: () -> Void

    private let timeBasedUnits = ["hours", "days", "weeks", "months"]
    private let periods = ["day", "week", "month"]

    @State private var timeBasedSelectedUnit: String = "hours"

    var body: some View {
        VStack {
            Text("Goal Type and Metrics")
                .font(.title)
                .padding()

            Picker("Goal Type", selection: $selectedType) {
                Text("Time-Based").tag(GoalType.timeBased)
                Text("Consistency-Based").tag(GoalType.consistencyBased)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedType) {
                updateSelectedUnitForType()
            }

            if selectedType == .timeBased {
                timeBasedInputSection
            } else if selectedType == .consistencyBased {
                consistencyBasedInputSection
            }

            Spacer()

            HStack {
                Button(action: onBack) {
                    Text("Back")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                Button(action: {
                    applySelectedUnit()
                    onNext()
                }) {
                    Text("Next")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            initializeSelectedUnit()
        }
    }

    private var timeBasedInputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Stepper(value: $metricValue, in: 1...100) {
                Text("\(Int(metricValue))")
            }
            .padding()

            Picker("Unit", selection: $timeBasedSelectedUnit) {
                ForEach(timeBasedUnits, id: \.self) { unit in
                    Text(unit).tag(unit)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Picker("Period", selection: $selectedPeriod) {
                ForEach(periods, id: \.self) { period in
                    Text(period.capitalized).tag(period)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
        }
    }

    private var consistencyBasedInputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Stepper(value: $metricValue, in: 1...100) {
                Text("Metric Value: \(Int(metricValue))")
            }
            .padding()

            Text("Unit: Times") // Static text for the unit
                .font(.headline)
                .padding()

            Picker("Period", selection: $selectedPeriod) {
                ForEach(periods, id: \.self) { period in
                    Text(period.capitalized).tag(period)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
        }
    }

    // Helper Functions

    private func initializeSelectedUnit() {
        if selectedType == .timeBased {
            timeBasedSelectedUnit = timeBasedUnits.first ?? "hours"
        } else {
            selectedUnit = "times"
        }
    }

    private func updateSelectedUnitForType() {
        if selectedType == .timeBased {
            timeBasedSelectedUnit = timeBasedUnits.first ?? "hours"
        } else {
            selectedUnit = "times"
        }
    }

    private func applySelectedUnit() {
        if selectedType == .timeBased {
            selectedUnit = timeBasedSelectedUnit
        } else {
            selectedUnit = "times" // Pre-set the unit for consistency-based goals
        }
    }
}
