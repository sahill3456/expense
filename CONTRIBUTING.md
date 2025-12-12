# Contributing to Expense Tracker

Thank you for your interest in contributing to the Expense Tracker app! We welcome contributions from the community.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/expense_tracker.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Install dependencies: `flutter pub get`

## Development Guidelines

### Code Style

- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused on a single responsibility
- Use `const` constructors wherever possible

### Architecture

This project follows the MVVM (Model-View-ViewModel) pattern:
- **Models** (`lib/models/`): Data structures and business entities
- **Views** (`lib/screens/`): UI components and screens
- **ViewModels** (`lib/providers/`): Business logic and state management
- **Services** (`lib/services/`): External service integrations

### State Management

We use Provider for state management:
- Use `ChangeNotifier` for complex state
- Call `notifyListeners()` after state changes
- Use `Consumer` or `Provider.of` to access state in widgets
- Keep business logic in providers, not in widgets

### Database

We use Hive for local storage:
- All database operations are in `lib/services/database_service.dart`
- Use Hive adapters for model serialization (`.g.dart` files)
- Run `flutter pub run build_runner build` after model changes

### Naming Conventions

- Files: `lowercase_with_underscores.dart`
- Classes: `PascalCase`
- Functions/Variables: `camelCase`
- Constants: `lowerCamelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants
- Private members: Prefix with `_`

## Making Changes

### Before Submitting

1. Test your changes thoroughly
2. Ensure your code follows the style guide
3. Update documentation if needed
4. Add comments for complex logic
5. Run `flutter analyze` to check for issues
6. Run `flutter test` to ensure tests pass

### Commit Messages

Follow conventional commit format:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `style:` for formatting changes
- `refactor:` for code refactoring
- `test:` for test additions/changes
- `chore:` for maintenance tasks

Example: `feat: add expense filtering by date range`

### Pull Request Process

1. Update the README.md if you add new features
2. Ensure all tests pass
3. Update the CHANGELOG.md with your changes
4. Request review from maintainers
5. Address any feedback or requested changes

## Adding New Features

### New Expense Categories

1. Add the category to `ExpenseCategory` enum in `lib/models/expense_model.dart`
2. Update the category selection UI in `lib/screens/expenses/add_expense_screen.dart`
3. Add corresponding emoji and color in the theme

### New Badges/Achievements

1. Add the badge type to `BadgeType` enum in `lib/models/badge_model.dart`
2. Implement unlock logic in `lib/providers/badge_provider.dart`
3. Update the badges screen UI in `lib/screens/gamification/badges_screen.dart`

### New Charts/Insights

1. Add chart logic in `lib/screens/insights/insights_screen.dart`
2. Use FL Chart package for visualization
3. Ensure data is properly formatted for the chart

## Testing

### Widget Tests

```dart
testWidgets('Description of test', (WidgetTester tester) async {
  await tester.pumpWidget(MyWidget());
  expect(find.text('Expected Text'), findsOneWidget);
});
```

### Provider Tests

```dart
test('Description of provider test', () {
  final provider = ExpenseProvider();
  // Test provider methods and state changes
});
```

## Code Review

All submissions require review. We use GitHub pull requests for this purpose:
- Be respectful and constructive
- Respond to feedback promptly
- Be open to suggestions and alternative approaches

## Questions?

If you have questions about contributing, please:
- Open an issue with the `question` label
- Join our community discussions
- Check existing issues and documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to make Expense Tracker better! 🎉
