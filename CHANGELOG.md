# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-12

### Added
- Initial release of Expense Tracker Gen Z Edition
- User authentication with email and Google Sign-In
- Add, edit, and delete expenses with detailed information
- Smart categorization with 8 predefined categories
- Real-time expense tracking and balance calculation
- Monthly and weekly expense summaries with visual charts
- Advanced filtering and search functionality
- Modern, vibrant UI design with gradient colors
- Dark mode support for enhanced user experience
- Gamification system with badges and achievements
- Bill-splitting feature for shared expenses
- Recurring expenses management (daily, weekly, monthly, yearly)
- Spending insights and personalized recommendations
- Social sharing capabilities for expense summaries
- Hive database for fast, offline-first data persistence
- Provider-based state management
- Firebase integration for authentication
- FL Chart integration for beautiful data visualizations
- Smooth animations using Animate Do package
- Custom theme system with Poppins and Inter fonts

### Features
#### Core Features
- Complete expense CRUD operations
- Category-based expense organization
- Date and amount range filtering
- Search functionality across all expenses
- Real-time balance calculations

#### Gen Z Features
- Vibrant gradient-based UI design
- Dark/Light theme toggle
- Achievement badges:
  - First Step (add first expense)
  - Tracker Pro (10 expenses)
  - Tracking Master (100 expenses)
  - Consistent (7-day streak)
  - Dedicated (30-day streak)
  - Social Butterfly (share expenses)
  - Bill Splitter (split an expense)
  - Budget Master (stay under budget)
  - Spending Analyzer (view insights)
- Social media integration for sharing
- Bill splitting with friends
- Recurring expense automation

#### Analytics & Insights
- Monthly spending line chart
- Weekly spending bar chart
- Category-wise pie chart
- Expense trends and patterns
- Top spending categories
- Average daily/weekly/monthly spending

### Technical
- Clean MVVM architecture
- Provider state management pattern
- Hive local database integration
- Firebase Authentication
- Material Design 3 (Material You)
- Responsive design for all screen sizes
- Offline-first approach
- Custom Hive adapters for models

### Dependencies
- provider: ^6.0.0
- hive: ^2.2.3
- hive_flutter: ^1.1.0
- firebase_core: ^2.24.0
- firebase_auth: ^4.10.0
- google_sign_in: ^6.2.0
- fl_chart: ^0.65.0
- animate_do: ^3.1.2
- intl: ^0.19.0
- uuid: ^4.0.0
- shared_preferences: ^2.2.1

---

## Future Releases

### Planned for v1.1.0
- [ ] Cloud sync across devices
- [ ] Budget alerts and notifications
- [ ] Export to PDF/CSV
- [ ] Receipt scanning with OCR
- [ ] Multi-currency support
- [ ] Enhanced accessibility features

### Planned for v1.2.0
- [ ] Advanced analytics with ML predictions
- [ ] Collaborative real-time bill splitting
- [ ] Investment tracking
- [ ] Net worth calculations
- [ ] Custom categories
- [ ] Expense templates

---

For more information about each release, see the [GitHub Releases](https://github.com/yourusername/expense_tracker/releases) page.
