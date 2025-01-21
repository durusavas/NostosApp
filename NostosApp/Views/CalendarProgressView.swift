//
//  CalendarProgressView.swift
//  NostosApp
//
//  Created by Duru SAVAŞ on 04/01/2025.
//

import SwiftUI

struct CalendarProgressView: View {
    @State var goal: Goal
    @State private var currentDate: Date = Date()
    
    // Configures the calendar to start the week on Monday
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        return calendar
    }
    
    // Generates an array of dates for the current month
    private var daysInCurrentMonth: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else { return [] }
        
        let firstWeekday = (calendar.component(.weekday, from: firstDay) - calendar.firstWeekday + 7) % 7
        let days = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDay)
        }
        return Array(repeating: nil, count: firstWeekday) + days // Adds padding for the first week
    }
    
    // Formats the current month and year as a title
    private var monthYearTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: goToPreviousMonth) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("textColor"))
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text(monthYearTitle)
                        .font(.custom("BellotaText-Regular", size: 20))
                        .foregroundColor(Color("textColor"))
                    
                    Spacer()
                    
                    Button(action: goToNextMonth) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color("textColor"))
                            .padding()
                    }
                }
                .padding()
                
                // Goal title
                Text("Progress for \(goal.title)")
                    .font(.custom("BellotaText-Regular", size: 24))
                    .foregroundColor(Color("textColor"))
                    .padding()
                
                // Calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                    // Weekday headers
                    ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                        Text(day)
                            .font(.custom("BellotaText-Regular", size: 16))
                            .foregroundColor(Color("textColor"))
                            .frame(maxWidth: .infinity)
                    }
                    // Days in the current month
                    ForEach(Array(daysInCurrentMonth.enumerated()), id: \.0) { index, date in
                        if let date = date {
                            let isCompleted = goal.completedDates.contains { completedDate in
                                calendar.isDate(completedDate, inSameDayAs: date)
                            }
                            
                            // Display each day with completion status
                            Text("\(calendar.component(.day, from: date))")
                                .font(.custom("BellotaText-Regular", size: 16))
                                .foregroundColor(isCompleted ? Color("nostosNoir") : Color("textColor"))
                                .frame(width: 40, height: 40)
                                .background(isCompleted ? goal.category.color : Color.clear)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(isCompleted ? goal.category.color : Color("textColor"), lineWidth: 1)
                                )
                        } else {
                            Text("") // Empty space for days outside the current month
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func goToPreviousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
    }
    
    private func goToNextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
    }
}
