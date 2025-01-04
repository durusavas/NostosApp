//
//  Untitled.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import Foundation

extension Date {
    func daysUntil(to date: Date) -> Int {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: self)
        let toDate = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return components.day ?? 0
    }
}
