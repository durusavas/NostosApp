//
//  StepGoalTypeView.swift
//  NostosApp
//

import SwiftUI

struct StepGoalTypeView: View {
    @Binding var selectedType: GoalType
    @Binding var metricValue: Double
    @Binding var selectedUnit: String
    @Binding var selectedPeriod: String
    let onNext: () -> Void
    let onBack: () -> Void
    
    private let timeBasedUnits = [
        NSLocalizedString("hours", comment: "Time unit for goals"),
        NSLocalizedString("days", comment: "Time unit for goals"),
        NSLocalizedString("weeks", comment: "Time unit for goals"),
        NSLocalizedString("months", comment: "Time unit for goals")
    ]
    private let periods = [
        NSLocalizedString("day", comment: "Tracking period for goals"),
        NSLocalizedString("week", comment: "Tracking period for goals"),
        NSLocalizedString("month", comment: "Tracking period for goals")
    ]
    
    @State private var timeBasedSelectedUnit: String = NSLocalizedString("hours", comment: "Default time unit")
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(NSLocalizedString("Metrics", comment: "Title for metrics step"))
                    .font(.custom("BellotaText-Regular", size: 30))
                    .foregroundColor(Color("textColor"))
                    .padding()
                
                // Goal Type Picker
                goalTypePicker
                
                // Metric Input Section
                metricInputSection
                
                Spacer()
                
                // Navigation Buttons
                navigationButtons
            }
            .padding()
        }
    }
    
    private var goalTypePicker: some View {
        HStack {
            ForEach(GoalType.allCases, id: \.self) { type in
                goalTypePickerItem(type: type)
            }
        }
        .padding()
    }
    
    private func goalTypePickerItem(type: GoalType) -> some View {
        Text(type == .timeBased
             ? NSLocalizedString("Time-Based", comment: "Goal type option")
             : NSLocalizedString("Consistency-Based", comment: "Goal type option"))
            .font(.custom("BellotaText-Regular", size: 13))
            .foregroundColor(Color("textColor"))
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                selectedType == type
                ? Color("textColor").opacity(0.2)
                : Color.clear
            )
            .cornerRadius(30)
            .onTapGesture {
                withAnimation {
                    selectedType = type
                    updateSelectedUnitForType()
                }
            }
    }
    
    private var metricInputSection: some View {
        Group {
            if selectedType == .timeBased {
                timeBasedInputSection
            } else {
                consistencyBasedInputSection
            }
        }
    }
    
    private var timeBasedInputSection: some View {
        VStack(alignment: .center, spacing: 16) {
            metricStepper
            
            HStack(spacing: 10) {
                WheelPicker(items: timeBasedUnits, selectedItem: $timeBasedSelectedUnit)
                Text("/")
                    .font(.custom("BellotaText-Light", size: 48))
                WheelPicker(items: periods, selectedItem: $selectedPeriod)
            }
            .frame(maxHeight: 120)
        }
        .padding()
    }
    
    private var consistencyBasedInputSection: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Spacer()
                metricStepper
                Text(NSLocalizedString("times", comment: "Unit for consistency goals"))
                    .font(.custom("BellotaText-Regular", size: 18))
                Spacer()
            }
            WheelPicker(items: periods, selectedItem: $selectedPeriod)
                .frame(maxHeight: 200)
        }
        .padding()
    }
    
    private var metricStepper: some View {
        VStack(spacing: 1) {
            Button(action: incrementMetric) {
                Image(systemName: "chevron.up")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("textColor"))
            }
            Text("\(Int(metricValue))")
                .font(.custom("BellotaText-Regular", size: 108))
                .foregroundColor(Color("textColor"))
            Button(action: decrementMetric) {
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("textColor"))
            }
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color("textColor"))
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                applySelectedUnit()
                onNext()
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color("textColor"))
            }
            .padding()
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper Functions
    private func updateSelectedUnitForType() {
        if selectedType == .timeBased {
            timeBasedSelectedUnit = timeBasedUnits.first ?? NSLocalizedString("hours", comment: "Default time unit")
        } else {
            selectedUnit = NSLocalizedString("times", comment: "Default unit for consistency-based goals")
        }
    }
    
    private func applySelectedUnit() {
        if selectedType == .timeBased {
            selectedUnit = timeBasedSelectedUnit
        } else {
            selectedUnit = NSLocalizedString("times", comment: "Default unit for consistency-based goals")
        }
    }
    
    private func incrementMetric() {
        if metricValue < 100 {
            metricValue += 1
        }
    }
    
    private func decrementMetric() {
        if metricValue > 1 {
            metricValue -= 1
        }
    }
}

struct WheelPicker: View {
    let items: [String]
    @Binding var selectedItem: String 
    
    var body: some View {
        Picker("", selection: $selectedItem) {
            ForEach(items, id: \.self) { item in
                Text(item.capitalized)
                    .font(.custom("BellotaText-Regular", size: 18))
                    .foregroundColor(Color("textColor"))
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(maxWidth: 100)
    }
}
