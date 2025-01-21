//
//  GoalsListView.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct GoalsListView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var selectedTimeframe: String = NSLocalizedString("Daily", comment: "Timeframe picker option")
    @State private var activeGoals: Set<UUID> = []
    private let timeframes = [
        NSLocalizedString("Daily", comment: "Timeframe picker option"),
        NSLocalizedString("Weekly", comment: "Timeframe picker option"),
        NSLocalizedString("Monthly", comment: "Timeframe picker option")
    ]

    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()

            VStack {
                // Timeframe Picker
                timeframePicker

                // Goals List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredGoals, id: \.id) { goal in
                            goalRow(for: goal)
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("Goals", comment: "Toolbar title"))
                        .font(.custom("BellotaText-Bold", size: 35))
                        .foregroundColor(Color("textColor"))
                }
            }
            .onAppear {
                viewModel.resetCompletionsIfNeeded()
            }
        }
    }


    private var timeframePicker: some View {
        HStack {
            ForEach(timeframes, id: \.self) { timeframe in
                Text(timeframe)
                    .font(.custom("BellotaText-Regular", size: 16))
                    .foregroundColor(Color("textColor"))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        timeframe == selectedTimeframe
                            ? Color("textColor").opacity(0.2)
                            : Color.clear
                    )
                    .cornerRadius(30)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                            selectedTimeframe = timeframe
                        }
                    }
            }
        }
        .padding()
    }


    private func goalRow(for goal: Goal) -> some View {
        HStack {
            // Check Button with Toggle Logic
            Button(action: {
                handleCheck(for: goal)
            }) {
                let currentCompletions = viewModel.completions[goal.id] ?? 0
                let isActive = activeGoals.contains(goal.id) || currentCompletions == Int(goal.metric.value)

                Image(systemName: isActive ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isActive ? goal.category.color : Color("textColor"))
                    .scaleEffect(isActive ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isActive)
            }

            Text(goal.title)
                .font(.custom("BellotaText-Regular", size: 16))
                .foregroundColor(Color("textColor"))

            Spacer()

            progressCircles(for: goal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color("textColor"), lineWidth: 1)
        )
    }

    private func progressCircles(for goal: Goal) -> some View {
        let metricValue = Int(goal.metric.value)
        let currentCompletions = min(viewModel.completions[goal.id] ?? 0, metricValue)

        return Group {
            if metricValue > 5 {
                // Show progress as text for large metrics
                Text("\(currentCompletions)/\(metricValue)")
                    .font(.custom("BellotaText-Regular", size: 16))
                    .foregroundColor(goal.category.color)
            } else {
                // Show circles for smaller metrics
                HStack(spacing: 5) {
                    ForEach(0..<metricValue, id: \.self) { index in
                        Circle()
                            .fill(index < currentCompletions ? goal.category.color : Color.clear)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(goal.category.color, lineWidth: 2)
                            )
                    }
                }
            }
        }
    }

    private var filteredGoals: [Goal] {
        switch selectedTimeframe {
        case NSLocalizedString("Daily", comment: "Timeframe filter"):
            return viewModel.filterGoals(by: "day")
        case NSLocalizedString("Weekly", comment: "Timeframe filter"):
            return viewModel.filterGoals(by: "week")
        case NSLocalizedString("Monthly", comment: "Timeframe filter"):
            return viewModel.filterGoals(by: "month")
        default:
            return []
        }
    }

    
    private func handleCheck(for goal: Goal) {
        withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.logCheck(for: goal)
        }

        let currentCompletions = viewModel.completions[goal.id] ?? 0
        let maxCompletions = Int(goal.metric.value)

        // If max completions are reached, keep the checkbox visible
        if currentCompletions >= maxCompletions {
            _ = activeGoals.insert(goal.id) // Explicitly ignore the return value
        } else {
            // Temporarily show the checkbox for a couple of seconds
            _ = activeGoals.insert(goal.id)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    _ = activeGoals.remove(goal.id)
                }
            }
        }
    }

}

struct GoalsListView_Previews: PreviewProvider {
    static var previews: some View {
        let demoViewModel = GoalViewModel()
        GoalsListView(viewModel: demoViewModel)
    }
}

