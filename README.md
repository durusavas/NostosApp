# nostos+

### Your Journey to Achieving Goals Made Simple

**nostos+** is a minimalist, user-friendly app for setting, tracking, and achieving your goals. Whether you’re striving for personal growth, building new habits, or managing your daily to-dos, **nostos+** provides the tools you need to stay organized and motivated.

---

## ✨ Features

- 📝 **Set Custom Goals**: Define your goals with fully customizable options.
- 📆 **Flexible Timeframes**: Track your goals by day, week, or month—tailored to your preferences.
- 📊 **Visual Progress Tracking**: See your progress at a glance with intuitive visuals.
- 🗂️ **Organized by Categories**: Group your goals into categories like Lifestyle, Financial, Relationships and Personal Growth.

---

## 📸 Screenshots
![bss1](https://github.com/user-attachments/assets/c189f350-39d4-4dcd-8dea-0b62918385f9)![bss2](https://github.com/user-attachments/assets/fa2affb4-dd2d-4a6d-9a58-c9c258371a56)



---

## 🖼️ Views Overview

### **📌 MainTabView**
- Acts as the entry point for the app.
- Contains a **Tab Bar** with three primary sections:
  1. **Goals List**: View and manage all goals.
  2. **Add Goal**: Create a new goal using a guided step-by-step interface.
  3. **Progress Overview**: Visualize your progress across all goals.

---

### **📋 GoalsListView**
- Displays a list of all active goals.
- **Features**:
  - 🔄 **Timeframe Picker**: Switch between Daily, Weekly, and Monthly views.
  - ✅ **Goal Rows**: Each goal displays a title, category, and progress.

---

### **➕ AddGoalView**
- A step-by-step guide for creating a new goal.
- **Steps**:
  1. 🏷️ **Set Goal Name**: Define what you want to achieve.
  2. ⚖️ **Select Goal Type**: Choose between:
     - Time-Based (e.g., "Run 5 km daily").
     - Consistency-Based (e.g., "Exercise 3 times a week").
  3. 🗓️ **Set a Deadline**: Choose a specific date or a timeframe (e.g., days, weeks).
  4. 🗂️ **Select a Category**: Group your goal into a predefined category (e.g., Personal Growth, Financial).

---

### **📈 GoalProgressView**
- Visualize progress for all goals.
- **Circle View**: Display goal progress as circular progress bars.
- **List View**: View goals in a detailed list format.
- **Progress Insights**: See percentages and remaining milestones for each goal.

---

### **🗓️ CalendarProgressView**
- Displays a calendar with highlighted days where progress was recorded.
- Helps track streaks and patterns over time.

---

### **🔧 StepGoalView Series**
- Modular views for each step in the goal creation process:
  - **StepGoalNameView**: Set the goal name.
  - **StepGoalTypeView**: Select time-based or consistency-based metrics.
  - **StepGoalDeadlineView**: Set deadlines with flexible options (e.g., days, weeks, or end of the year).
  - **StepGoalCategoryView**: Organize goals into predefined categories.

---

## 🏛️ Architecture

The app is built using **MVVM (Model-View-ViewModel)** architecture for maintainability and scalability.

### **📦 Models**
- **Goal**: Represents an individual goal with properties like title, type, metric, deadline, and category.
- **Metric**: Encapsulates goal metrics such as value, unit, and tracking period.
- **Category**: Enumerates predefined goal categories (e.g., Lifestyle, Educational).

### **📂 Data Persistence**
nostos+ uses **SwiftData**, Apple's lightweight persistence framework, to efficiently manage and store user goals and progress data. SwiftData ensures:
- Seamless integration with SwiftUI.
- Robust handling of data relationships and updates.
- Offline availability, so users can access their goals even without an internet connection.

### **🧠 ViewModels**
- **GoalViewModel**:
  - Manages goal creation, progress tracking, and filtering by timeframes.
  - Handles state for goal-related operations.

### **🎨 Views**
- Built with **SwiftUI** for a modern and declarative UI.
- **Custom reusable components**:
  - `WheelPicker`: A smooth picker for selecting metrics and timeframes.
  - `ProgressCircles`: Visual progress indicators for goals.

---

## 🚀 Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/durusavas/nostosApp.git
   cd nostosApp
---

## 📜 License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.

---


