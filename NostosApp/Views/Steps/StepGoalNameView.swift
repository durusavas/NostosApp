//
//  StepGoalNameView.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct StepGoalNameView: View {
    @Binding var title: String
    let onNext: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text(NSLocalizedString("What's your goal?", comment: "Prompt for the user to enter their goal"))
                    .font(.custom("BellotaText-Regular", size: 30))
                    .foregroundColor(Color("textColor"))
                    .padding()

                TextField(NSLocalizedString("My goal is...", comment: "Placeholder for goal input"), text: $title)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.custom("BellotaText-Regular", size: 18))
                    .foregroundColor(Color("textColor"))
                    .background(Color.clear)
                    .padding()
                    .focused($isFocused)
                    .onTapGesture {
                        isFocused = true
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color("textColor"), lineWidth: 1)
                    )
                    .padding(.horizontal)

                Spacer()

                Button(action: {
                    isFocused = false // Dismiss keyboard
                    onNext()
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("textColor"))
                }
                .padding()
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.1 : 1.0)
            }
            .padding()
        }
    }
}

struct StepGoalNameView_Previews: PreviewProvider {
    @State static var previewTitle: String = ""

    static var previews: some View {
        StepGoalNameView(title: $previewTitle, onNext: {
            print("Next button pressed with title: \(previewTitle)")
        })
            .previewLayout(.sizeThatFits)
    }
}
