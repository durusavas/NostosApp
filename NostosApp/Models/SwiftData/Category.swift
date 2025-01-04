//
//  Category.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import Foundation
import SwiftData
import SwiftUI

enum Category: String, CaseIterable, Codable {
    case personalGrowth = "Personal Growth"
    case educational = "Educational"
    case relationships = "Relationships"
    case financial = "Financial"
    case lifestyle = "Lifestyle"

    var color: Color {
        switch self {
        case .personalGrowth: return .purple
        case .educational: return .green
        case .relationships: return .pink
        case .financial: return .blue
        case .lifestyle: return .yellow
        }
    }

    var description: String {
        switch self {
        case .personalGrowth: return "Skills, Hobbies, Health"
        case .educational: return "Degrees, Certifications, Career Milestones"
        case .relationships: return "Family, Friendships, Romantic"
        case .financial: return "Savings, Investments, Purchases"
        case .lifestyle: return "Travel, Experiences, Routines"
        }
    }
}
