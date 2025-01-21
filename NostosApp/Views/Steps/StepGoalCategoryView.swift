//
//  StepGoalCategoryView.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct StepGoalCategoryView: View {
    @Binding var selectedCategory: Category
    let onNext: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text(NSLocalizedString("Select a Category", comment: "Title for category step"))
                    .font(.custom("BellotaText-Regular", size: 30))
                    .foregroundColor(Color("textColor"))
                    .padding(.top)
                
                Spacer()
                
                // List of categories
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Category.allCases, id: \.self) { category in
                            HStack {
                                Text(category.localizedName)
                                    .font(.custom("BellotaText-Regular", size: 18))
                                    .foregroundColor(Color("nostosNoir"))
                                    .padding(.leading, 16)
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(category.color)
                                    .opacity(selectedCategory == category ? 1.0 : 0.55)
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Display description of the selected category
                Text(selectedCategory.localizedDescription)
                    .font(.custom("BellotaText-Regular", size: 16))
                    .foregroundColor(Color("textColor"))
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                Spacer()
                
                // Navigation buttons
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("textColor"))
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: onNext) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("textColor"))
                    }
                    .padding()
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct StepGoalCategoryView_Previews: PreviewProvider {
    @State static var selectedCategory: Category = .personalGrowth
    
    static var previews: some View {
        StepGoalCategoryView(
            selectedCategory: $selectedCategory,
            onNext: { print("Next tapped") },
            onBack: { print("Back tapped") }
        )
    }
}
