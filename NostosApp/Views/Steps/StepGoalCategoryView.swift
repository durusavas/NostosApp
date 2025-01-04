//
//  StepGoalCategoryView.swift
//  nostos
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct StepGoalCategoryView: View {
    @Binding var selectedCategory: Category
    let onNext: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack {
            Text("Select a Category")
                .font(.title)
                .padding()

            Picker("Category", selection: $selectedCategory) {
                ForEach(Category.allCases, id: \.self) { category in
                    Text(category.rawValue)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            Text(selectedCategory.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()

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

                Button(action: onNext) {
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
    }
}
