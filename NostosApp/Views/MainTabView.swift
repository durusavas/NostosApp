//
//  MainTabView.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = GoalViewModel()

    var body: some View {
        TabView {
            NavigationView {
                GoalsListView(viewModel: viewModel)
            }
            .tabItem {
                Label("Goals", systemImage: "list.bullet")
            }

            NavigationView {
                GoalProgressView(viewModel: viewModel)
            }
            .tabItem {
                Label("Progress", systemImage: "chart.bar")
            }

            NavigationView {
                AddGoalView(viewModel: viewModel)
            }
            .tabItem {
                Label("Add Goal", systemImage: "plus.circle")
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
