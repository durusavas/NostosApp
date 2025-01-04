//
//  StepGoalNameView.swift
//  nostos
//
//  Created by Duru SAVAŞ on 04/01/2025.
//
import SwiftUI

struct StepGoalNameView: View {
    @Binding var title: String
    let onNext: () -> Void

    var body: some View {
        VStack {
            Text("What's your goal?")
                .font(.title)
                .padding()

            TextField("Enter Goal Name", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Spacer()

            Button(action: onNext) {
                Text("Next")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .disabled(title.isEmpty)
        }
        .padding()
    }
}
