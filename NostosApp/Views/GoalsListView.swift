//
//  GoalsListView.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct GoalsListView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var selectedTimeframe: String = "Daily"
    
    var body: some View {
        VStack {
            Picker("Select Timeframe", selection: $selectedTimeframe) {
                Text("Daily").tag("Daily")
                Text("Weekly").tag("Weekly")
                Text("Monthly").tag("Monthly")
                
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            List(filteredGoals, id: \.id) { goal in
                HStack {
                    Button(action: {
                        viewModel.logCheck(for: goal)
                    }) {
                        Image(systemName: viewModel.checks[goal.id] ?? 0 > 0 ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(viewModel.checks[goal.id] ?? 0 > 0 ? .green : .gray)
                    }
                    
                    Text(goal.title)
                }
                .padding()
                .background(goal.category.color.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .navigationTitle("\(selectedTimeframe) Goals")
        .onAppear {
            viewModel.filterGoalsByTimeframe()
        }
    }
    
    var filteredGoals: [Goal] {
        switch selectedTimeframe {
        case "Daily":
            return viewModel.dailyGoals
        case "Weekly":
            return viewModel.weeklyGoals
        case "Monthly":
            return viewModel.monthlyGoals
            
        default:
            return []
        }
    }
}


struct GoalsListView_Previews: PreviewProvider {
    static var previews: some View {
        let demoViewModel = GoalViewModel()
        
        // Add mock data to the view model
        let mockGoals = [
            Goal(
                title: "Study Swift",
                type: .timeBased,
                metric: Metric(label: "Hours per Week", value: 5.0, unit: "hours", period: "week", isCustom: false),
                deadline: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
                progress: 40.0,
                category: .educational
            ),
            Goal(
                title: "Exercise Regularly",
                type: .consistencyBased,
                metric: Metric(label: "Sessions per Week", value: 3.0, unit: "times", period: "day", isCustom: false),
                deadline: Date(),
                progress: 66.0,
                category: .personalGrowth
            ),
            Goal(
                title: "Submit Project",
                type: .consistencyBased,
                metric: Metric(label: "Sessions per Week", value: 3.0, unit: "times", period: "week", isCustom: false),
                deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                progress: 100.0,
                category: .educational
            ),
            Goal(
                title: "Save Money",
                type: .consistencyBased,
                metric: Metric(label: "Savings per Month", value: 500, unit: "dollars", period: "month", isCustom: false),
                deadline: Date(),
                progress: 20.0,
                category: .financial
            ),
            
        ]
        
        demoViewModel.goals = mockGoals
        demoViewModel.filterGoalsByTimeframe()
        
        return NavigationView {
            GoalsListView(viewModel: demoViewModel)
        }
    }
}
