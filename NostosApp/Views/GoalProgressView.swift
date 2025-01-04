//
//  GoalProgressView.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI
import SwiftData

struct GoalProgressView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var selectedGoal: Goal? = nil

    var body: some View {
        VStack {
            Text("Goal Progress")
                .font(.title)
                .padding()

            List(viewModel.goals, id: \.id) { goal in
                HStack {
                    Text(goal.title)
                    Spacer()
                    Text("\(Int(viewModel.calculateProgress(for: goal, checks: viewModel.checks[goal.id] ?? 0)))%")
                        .foregroundColor(.blue)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedGoal = goal
                }
            }
        }
        .navigationTitle("All Goals Progress")
        .sheet(item: $selectedGoal) { goal in
            CalendarProgressView(goal: goal)
        }
    }
}

struct GoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let demoViewModel = GoalViewModel()

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
                metric: Metric(label: "Sessions per Week", value: 3.0, unit: "sessions", period: "week", isCustom: false),
                deadline: Date(),
                progress: 66.0,
                category: .financial
            ),
            Goal(
                title: "Submit Project",
                type: .consistencyBased,
                metric: Metric(label: "Complete Task", value: 1.0, unit: "task", period: "week", isCustom: false),
                deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                progress: 100.0,
                category: .relationships
            )
        ]

        demoViewModel.goals = mockGoals
        demoViewModel.checks[mockGoals[0].id] = 2
        demoViewModel.checks[mockGoals[1].id] = 2
        demoViewModel.checks[mockGoals[2].id] = 1 

        return NavigationView {
            GoalProgressView(viewModel: demoViewModel)
        }
    }
}
