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
    case personalGrowth = "PersonalGrowth"
    case educational = "Educational"
    case relationships = "Relationships"
    case financial = "Financial"
    case lifestyle = "Lifestyle"

    var color: Color {
        switch self {
        case .personalGrowth: return Color("personalGrowth")
        case .educational: return Color("educational")
        case .relationships: return Color("relationships")
        case .financial: return Color("financial")
        case .lifestyle: return Color("lifestyle")
        }
    }

    // Localized name for the category
    var localizedName: String {
        NSLocalizedString(rawValue, comment: "Localized name for the \(rawValue) category")
    }

    // Localized description for the category
    var localizedDescription: String {
        switch self {
        case .personalGrowth:
            return NSLocalizedString("Skills, Hobbies, Health", comment: "Description for Personal Growth category")
        case .educational:
            return NSLocalizedString("Degrees, Certifications, Career Milestones", comment: "Description for Educational category")
        case .relationships:
            return NSLocalizedString("Family, Friendships, Romantic", comment: "Description for Relationships category")
        case .financial:
            return NSLocalizedString("Savings, Investments, Purchases", comment: "Description for Financial category")
        case .lifestyle:
            return NSLocalizedString("Travel, Experiences, Routines", comment: "Description for Lifestyle category")
        }
    }
}
