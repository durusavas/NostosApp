//
//  CalendarProgressView.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct CalendarProgressView: View {
    @State var goal: Goal

    private var daysInCurrentMonth: [Date] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: Date()) else { return [] }
        let today = Date()
        let month = calendar.component(.month, from: today)
        let year = calendar.component(.year, from: today)
        return range.compactMap { day in
            calendar.date(from: DateComponents(year: year, month: month, day: day))
        }
    }

    var body: some View {
        VStack {
            Text("Progress for \(goal.title)")
                .font(.title)
                .padding()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                // Weekdays
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }

                // Days in current month
                ForEach(daysInCurrentMonth, id: \.self) { date in
                    let isCompleted = goal.completedDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }

                    Text("\(Calendar.current.component(.day, from: date))")
                        .frame(width: 40, height: 40)
                        .background(isCompleted ? goal.category.color : Color.clear)
                        .foregroundColor(isCompleted ? .white : .primary)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(isCompleted ? goal.category.color : .gray, lineWidth: 1)
                        )
                }
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}
