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
                Image(systemName: "list.bullet")
            }
            
            NavigationView {
                GoalProgressView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "chart.bar")
            }
            
            NavigationView {
                AddGoalView(viewModel: viewModel)
            }
            .tabItem {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
