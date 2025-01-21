//
//  StepGoalDeadlineView.swift
//  NostosApp
//

import SwiftUI

struct StepGoalDeadlineView: View {
    @Binding var deadline: Date
    @Binding var deadlineOption: String
    @Binding var customDeadline: Date
    let onBack: () -> Void
    let onSaveAndReset: (Date) -> Void
    
    private let deadlineOptions = [
        NSLocalizedString("Custom Picker", comment: "Deadline option"),
        NSLocalizedString("Custom Date", comment: "Deadline option"),
        NSLocalizedString("End of the Year", comment: "Deadline option")
    ]
    private let timeUnits = [
        NSLocalizedString("days", comment: "Time unit for custom picker"),
        NSLocalizedString("weeks", comment: "Time unit for custom picker"),
        NSLocalizedString("months", comment: "Time unit for custom picker")
    ]
    
    @State private var selectedUnit: String = NSLocalizedString("days", comment: "Default time unit")
    @State private var duration: Int = 1 // Duration for the custom picker
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(NSLocalizedString("Set a Deadline", comment: "Title for deadline step"))
                    .font(.custom("BellotaText-Regular", size: 30))
                    .foregroundColor(Color("textColor"))
                    .padding()
                
                // Deadline Option Picker
                deadlineOptionPicker
                
                // Conditional Pickers
                if deadlineOption == NSLocalizedString("Custom Picker", comment: "Deadline option") {
                    combinedPicker
                } else if deadlineOption == NSLocalizedString("Custom Date", comment: "Deadline option") {
                    customDatePicker
                } else if deadlineOption == NSLocalizedString("End of the Year", comment: "Deadline option") {
                    Text(daysLeftInYear())
                        .font(.custom("BellotaText-Regular", size: 16))
                        .foregroundColor(Color("textColor"))
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Spacer()
                
                navigationButtons
            }
            .padding()
        }
    }
    
    // Deadline Option Picker
    private var deadlineOptionPicker: some View {
        HStack(spacing: 12) {
            ForEach(deadlineOptions, id: \.self) { option in
                Text(option)
                    .font(.custom("BellotaText-Regular", size: 12))
                    .foregroundColor(Color("textColor"))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(
                        deadlineOption == option
                        ? Color("textColor").opacity(0.2)
                        : Color.clear
                    )
                    .cornerRadius(30)
                    .onTapGesture {
                        deadlineOption = option
                    }
            }
        }
        .padding(.horizontal)
    }
    
    // Combined Picker
    private var combinedPicker: some View {
        
        HStack(spacing: 16) {
            metricStepper
            WheelPicker(items: timeUnits, selectedItem: $selectedUnit)
                .frame(maxWidth: 150)
        }
        .frame(maxHeight: 120)
           .padding(.top, 80)
           .padding([.leading, .trailing])
    }
    
    private var metricStepper: some View {
        VStack(spacing: 1) {
            Button(action: incrementDuration) {
                Image(systemName: "chevron.up")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("textColor"))
            }
            
            Text("\(duration)")
                .font(.custom("BellotaText-Regular", size: 98))
                .foregroundColor(Color("textColor"))
            
            Button(action: decrementDuration) {
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color("textColor"))
            }
        }
    }
    
    // Custom Date Picker
    private var customDatePicker: some View {
        VStack {
            DatePicker("", selection: $customDeadline, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity, maxHeight: 400)
        }
    }
    
    // Navigation Buttons
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
            
            Button(action: saveGoal) {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color("textColor"))
            }
            .padding()
        }
        .padding(.horizontal)
    }
    
    // Save Goal
    private func saveGoal() {
        let calculatedDeadline = calculateDeadline()
        deadline = calculatedDeadline
        onSaveAndReset(calculatedDeadline)
    }
    
    private func daysLeftInYear() -> String {
        let calendar = Calendar.current
        let today = Date()
        let endOfYear = calendar.date(from: DateComponents(year: calendar.component(.year, from: today), month: 12, day: 31)) ?? Date()
        let daysLeft = calendar.dateComponents([.day], from: today, to: endOfYear).day ?? 0
        
        return String(format: NSLocalizedString("%d days left in the year.", comment: "Message for remaining days in the year"), daysLeft)
    }
    
    private func incrementDuration() {
        if duration < 100 {
            duration += 1
        }
    }
    
    private func decrementDuration() {
        if duration > 1 {
            duration -= 1
        }
    }
    
    private func calculateDeadline() -> Date {
        let calendar = Calendar.current
        
        switch deadlineOption {
        case NSLocalizedString("Custom Date", comment: "Deadline option"):
            return customDeadline
        case NSLocalizedString("End of the Year", comment: "Deadline option"):
            return calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: 12, day: 31)) ?? Date()
        case NSLocalizedString("Custom Picker", comment: "Deadline option"):
            let totalDays: Int
            switch selectedUnit {
            case NSLocalizedString("days", comment: "Time unit for custom picker"):
                totalDays = duration
            case NSLocalizedString("weeks", comment: "Time unit for custom picker"):
                totalDays = duration * 7
            case NSLocalizedString("months", comment: "Time unit for custom picker"):
                totalDays = duration * 30
            default:
                totalDays = 0
            }
            return calendar.date(byAdding: .day, value: totalDays, to: Date()) ?? Date()
        default:
            return Date()
        }
    }
}

struct StepGoalDeadlineView_Previews: PreviewProvider {
    @State static var deadline: Date = Date()
    @State static var deadlineOption: String = NSLocalizedString("Custom Picker", comment: "Preview option")
    @State static var customDeadline: Date = Date()
    
    static var previews: some View {
        StepGoalDeadlineView(
            deadline: $deadline,
            deadlineOption: $deadlineOption,
            customDeadline: $customDeadline,
            onBack: { print("Back tapped") },
            onSaveAndReset: { deadline in
                print("Saved deadline: \(deadline)")
            }
        )
    }
}
