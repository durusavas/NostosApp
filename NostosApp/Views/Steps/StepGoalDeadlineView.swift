//
//  StepGoalDeadlineView.swift
//  nostos
//
//  Created by Duru SAVAŞ on 04/01/2025.
//


import SwiftUI

struct StepGoalDeadlineView: View {
    @Binding var deadlineOption: String
    @Binding var customDeadline: Date
    let onBack: () -> Void
    let onSaveAndReset: () -> Void

    let deadlineOptions = ["End of the Year", "1 Month", "3 Months", "Custom Date"]

    var body: some View {
        VStack {
            Text("Set a Deadline")
                .font(.title)
                .padding()

            Picker("Deadline Options", selection: $deadlineOption) {
                ForEach(deadlineOptions, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if deadlineOption == "Custom Date" {
                DatePicker("Select Deadline", selection: $customDeadline, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
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

                Button(action: onSaveAndReset) {
                    Text("Save Goal")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
    }
}
