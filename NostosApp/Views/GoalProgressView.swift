//
//  GoalProgressView.swift
//  NostosApp
//

import SwiftUI

struct GoalProgressView: View {
    @ObservedObject var viewModel: GoalViewModel
    @State private var selectedViewType: ViewType = .circleView
    @State private var selectedGoal: Goal?
    @State private var isShowingCalendar: Bool = false
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack {
                // View Type Picker
                viewTypePicker
                
                // Conditional View Rendering
                if selectedViewType == .circleView {
                    circularProgressView
                } else {
                    listView
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(NSLocalizedString("All Goals Progress", comment: "Toolbar title for progress view"))
                        .font(.custom("BellotaText-Bold", size: 35))
                        .foregroundColor(Color("textColor"))
                }
            }
        }
        .sheet(isPresented: $isShowingCalendar) {
            if let goal = selectedGoal {
                CalendarProgressView(goal: goal)
            }
        }
    }

    private var viewTypePicker: some View {
        HStack {
            ForEach(ViewType.allCases, id: \.self) { viewType in
                Image(systemName: viewType.iconName)
                    .resizable()
                    .frame(width: 20, height: 18)
                    .foregroundColor(viewType == selectedViewType ? Color("textColor") : Color.gray)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(viewType == selectedViewType ? Color("textColor").opacity(0.2) : Color.clear)
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedViewType = viewType
                        }
                    }
            }
            .padding(.horizontal)
        }
        .padding()
    }

    
    private var circularProgressView: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(viewModel.goals, id: \.id) { goal in
                    VStack {
                        ZStack {
                            Circle()
                                .fill(goal.category.color.opacity(0.2))
                                .frame(width: 140, height: 140)
                            
                            if let progress = validatedProgress(for: goal) {
                                Circle()
                                    .fill(goal.category.color)
                                    .frame(width: 130, height: 130)
                                    .mask(
                                        GeometryReader { geometry in
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(
                                                    width: geometry.size.width,
                                                    height: geometry.size.height * CGFloat(progress) / 100
                                                )
                                                .offset(y: geometry.size.height * (1 - CGFloat(progress) / 100))
                                        }
                                    )
                                Text("\(Int(progress))%")
                                    .font(.custom("BellotaText-Regular", size: 24))
                                    .foregroundColor(Color("textColor"))
                            } else {
                                Text("N/A")
                                    .font(.custom("BellotaText-Regular", size: 24))
                                    .foregroundColor(Color("textColor"))
                            }
                        }
                        
                        Text(goal.title)
                            .font(.custom("BellotaText-Regular", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("textColor"))
                            .padding(.top, 8)
                            .onTapGesture {
                                selectedGoal = goal
                                isShowingCalendar = true
                            }
                    }
                }
            }
            .padding()
        }
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.goals, id: \.id) { goal in
                HStack {
                    Text(goal.title)
                        .font(.custom("BellotaText-Regular", size: 16))
                        .foregroundColor(Color("textColor"))
                    
                    Spacer()
                    
                    if let progress = validatedProgress(for: goal) {
                        Text("\(Int(progress))%")
                            .font(.custom("BellotaText-Regular", size: 16))
                            .foregroundColor(goal.category.color)
                    } else {
                        Text("N/A")
                            .font(.custom("BellotaText-Regular", size: 16))
                            .foregroundColor(Color("textColor"))
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color("textColor"), lineWidth: 1)
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .onTapGesture {
                    selectedGoal = goal
                    isShowingCalendar = true
                }
            }
            .onDelete(perform: deleteGoal)
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
    }
    
    private func validatedProgress(for goal: Goal) -> Double? {
        let progress = viewModel.calculateProgress(for: goal)
        guard progress.isFinite, progress >= 0, progress <= 100 else {
            print("Invalid progress: \(progress) for goal \(goal.title)")
            return nil
        }
        return progress
    }
    
    private func deleteGoal(at offsets: IndexSet) {
        offsets.forEach { index in
            let goal = viewModel.goals[index]
            viewModel.goals.removeAll { $0.id == goal.id }
        }
    }
}

enum ViewType: CaseIterable {
    case circleView
    case listView
    
    var iconName: String {
        switch self {
        case .circleView: return "circle.grid.2x2.fill" // Example icon for circle view
        case .listView: return "list.bullet"          // Example icon for list view
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
                normalizedDeadline: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
                completedDates: [],
                category: .educational
            ),
            Goal(
                title: "Exercise Regularly",
                type: .consistencyBased,
                metric: Metric(label: "Sessions per Week", value: 3.0, unit: "sessions", period: "week", isCustom: false),
                normalizedDeadline: Date(),
                completedDates: [],
                category: .lifestyle
            )
        ]
        
        demoViewModel.goals = mockGoals
        
        return NavigationView {
            GoalProgressView(viewModel: demoViewModel)
        }
    }
}
