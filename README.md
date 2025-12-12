# Expense Tracker - Gen Z Edition 💰

A modern, vibrant expense tracking mobile application built with Flutter, designed specifically for Gen Z users who want to understand and control their spending habits.

## Features

### Core Features
- **User Authentication**: Sign up/login with email or Google authentication
- **Expense Management**: Add, edit, and delete expenses with detailed information
- **Smart Categorization**: 8 predefined categories (Food & Dining, Fashion, Entertainment, Travel, Education, Health, Tech, Other)
- **Real-time Tracking**: Instant balance calculations and spending overview
- **Expense Analytics**: Monthly and weekly summaries with visual charts and graphs
- **Advanced Filtering**: Search and filter expenses by category, date, or amount range

### Gen Z-Specific Features
- **Modern UI Design**: Vibrant gradient colors, smooth animations, and trendy design patterns
- **Dark Mode Support**: Eye-friendly dark theme for night usage
- **Gamification**: Earn badges and achievements for tracking consistency
  - First Step (add first expense)
  - Tracker Pro (10 expenses)
  - Tracking Master (100 expenses)
  - Consistent (7-day streak)
  - Dedicated (30-day streak)
  - And more!
- **Bill Splitting**: Share expenses with friends and track who owes what
- **Recurring Expenses**: Set up automatic recurring expenses (daily, weekly, monthly, yearly)
- **Spending Insights**: Personalized recommendations based on spending patterns
- **Social Integration**: Share expense summaries and achievements

### Technical Features
- **State Management**: Provider pattern for efficient state handling
- **Local Storage**: Hive database for fast, offline-first data persistence
- **Responsive Design**: Optimized for various screen sizes
- **Clean Architecture**: MVVM pattern for maintainable code
- **Firebase Integration**: Cloud authentication and potential cloud backup
- **Cross-Platform**: Runs seamlessly on iOS and Android

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── config/
│   └── app_theme.dart       # Theme and color definitions
├── models/
│   ├── expense_model.dart   # Expense data model
│   ├── expense_model.g.dart # Hive adapter (generated)
│   ├── user_model.dart      # User data model
│   ├── user_model.g.dart    # Hive adapter (generated)
│   ├── badge_model.dart     # Badge/achievement model
│   └── badge_model.g.dart   # Hive adapter (generated)
├── services/
│   └── database_service.dart # Local database operations
├── providers/
│   ├── auth_provider.dart   # Authentication logic
│   ├── expense_provider.dart # Expense management logic
│   ├── theme_provider.dart  # Theme management
│   └── badge_provider.dart  # Gamification logic
├── screens/
│   ├── auth/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── expenses/
│   │   ├── add_expense_screen.dart
│   │   └── expense_list_screen.dart
│   ├── insights/
│   │   └── insights_screen.dart
│   ├── gamification/
│   │   └── badges_screen.dart
│   └── settings/
│       └── settings_screen.dart
```

## Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart 3.0.0 or higher
- iOS 11.0+ / Android 5.0+

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd expense_tracker
```

2. Install dependencies
```bash
flutter pub get
```

3. Set up Firebase
- Create a Firebase project at https://console.firebase.google.com
- Add iOS and Android apps to your Firebase project
- Download and add `GoogleService-Info.plist` for iOS
- Download and add `google-services.json` for Android
- Update `lib/firebase_options.dart` with your Firebase configuration

4. Run the app
```bash
flutter run
```

## Building

### Android
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Dependencies

### State Management
- **provider**: ^6.0.0 - Reactive dependency injection

### Database
- **hive**: ^2.2.3 - Lightweight NoSQL database
- **hive_flutter**: ^1.1.0 - Flutter integration for Hive

### Authentication
- **firebase_core**: ^2.24.0 - Firebase core
- **firebase_auth**: ^4.10.0 - Firebase authentication
- **google_sign_in**: ^6.2.0 - Google sign-in

### UI & Charts
- **fl_chart**: ^0.65.0 - Beautiful charts
- **animate_do**: ^3.1.2 - Animation package
- **flutter_svg**: ^2.0.7 - SVG support

### Utilities
- **intl**: ^0.19.0 - Internationalization
- **uuid**: ^4.0.0 - UUID generation
- **shared_preferences**: ^2.2.1 - Key-value storage

## App Theme

### Colors
- **Primary**: Indigo (#6366F1)
- **Secondary**: Purple (#A855F7)
- **Accent**: Pink (#EC4899)
- **Success**: Green (#10B981)
- **Warning**: Amber (#F59E0B)
- **Error**: Red (#EF4444)

### Fonts
- **Headings**: Poppins (Bold, SemiBold)
- **Body**: Inter (Regular)

## Future Enhancements

1. **Cloud Sync**: Synchronize data across devices
2. **Budget Alerts**: Notifications when approaching budget limits
3. **Export Options**: Export expenses to PDF/CSV
4. **Advanced Analytics**: ML-powered spending predictions
5. **Multi-currency Support**: Track expenses in different currencies
6. **Receipt Scanning**: OCR-based receipt capture
7. **Collaborative Features**: Real-time bill splitting with friends
8. **Investment Tracking**: Track investments and net worth
9. **Offline Support**: Better offline-first experience
10. **Accessibility**: Enhanced accessibility features

## Testing

Currently, the app focuses on functional testing. Unit tests and widget tests can be added using:
- **flutter_test**: Built-in Flutter testing framework
- **mockito**: For mocking dependencies

## Contributing

We welcome contributions! Please follow these guidelines:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@expensetracker.com or open an issue in the GitHub repository.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for authentication services
- The open-source community for excellent packages

---

**Made with 💙 for Gen Z budgeters**
