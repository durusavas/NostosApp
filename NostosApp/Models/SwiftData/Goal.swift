//
//  Goal.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import Foundation
import SwiftData
import SwiftUI

enum GoalType:String, Codable{
    case timeBased
    case consistencyBased
}
@Model
class Goal{
    var id: UUID
    var title: String
    var type: GoalType
    var metric: Metric
    var deadline: Date
    var progress: Double
    var completedDates: [Date]
    var category: Category
    
    init(
        id: UUID = UUID(),
        title: String,
        type: GoalType,
        metric: Metric,
        deadline: Date = Date(),
        progress: Double = 0.0,
        completedDates: [Date] = [],
        category: Category = .personalGrowth
    ){
        self.id = id
        self.title = title
        self.type = type
        self.metric = metric
        self.deadline = deadline
        self.progress = progress
        self.completedDates = completedDates
        self.category = category
        
    }
}
