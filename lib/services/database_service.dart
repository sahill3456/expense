import 'package:hive/hive.dart';
import '../models/expense_model.dart';
import '../models/user_model.dart';
import '../models/badge_model.dart';

class DatabaseService {
  static const String expensesBox = 'expenses';
  static const String userBox = 'user';
  static const String badgesBox = 'badges';

  static Future<void> addExpense(ExpenseModel expense) async {
    final box = Hive.box<ExpenseModel>(expensesBox);
    await box.put(expense.id, expense);
  }

  static Future<void> updateExpense(ExpenseModel expense) async {
    final box = Hive.box<ExpenseModel>(expensesBox);
    await box.put(expense.id, expense);
  }

  static Future<void> deleteExpense(String expenseId) async {
    final box = Hive.box<ExpenseModel>(expensesBox);
    await box.delete(expenseId);
  }

  static List<ExpenseModel> getAllExpenses() {
    final box = Hive.box<ExpenseModel>(expensesBox);
    return box.values.toList();
  }

  static List<ExpenseModel> getExpensesByUserId(String userId) {
    final box = Hive.box<ExpenseModel>(expensesBox);
    return box.values
        .where((expense) => expense.userId == userId)
        .toList();
  }

  static List<ExpenseModel> getExpensesByCategory(
      String userId, String category) {
    final box = Hive.box<ExpenseModel>(expensesBox);
    return box.values
        .where((expense) =>
            expense.userId == userId && expense.category == category)
        .toList();
  }

  static List<ExpenseModel> getExpensesByDateRange(
      String userId, DateTime startDate, DateTime endDate) {
    final box = Hive.box<ExpenseModel>(expensesBox);
    return box.values
        .where((expense) =>
            expense.userId == userId &&
            expense.date.isAfter(startDate) &&
            expense.date.isBefore(endDate))
        .toList();
  }

  static List<ExpenseModel> getExpensesByAmountRange(
      String userId, double minAmount, double maxAmount) {
    final box = Hive.box<ExpenseModel>(expensesBox);
    return box.values
        .where((expense) =>
            expense.userId == userId &&
            expense.amount >= minAmount &&
            expense.amount <= maxAmount)
        .toList();
  }

  static double getTotalExpenses(String userId) {
    final box = Hive.box<ExpenseModel>(expensesBox);
    return box.values
        .where((expense) => expense.userId == userId)
        .fold<double>(0, (sum, expense) => sum + expense.amount);
  }

  static double getMonthlyExpenses(String userId, int month, int year) {
    final box = Hive.box<ExpenseModel>(expensesBox);
    return box.values
        .where((expense) =>
            expense.userId == userId &&
            expense.date.month == month &&
            expense.date.year == year)
        .fold<double>(0, (sum, expense) => sum + expense.amount);
  }

  static double getWeeklyExpenses(String userId, DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    final box = Hive.box<ExpenseModel>(expensesBox);
    return box.values
        .where((expense) =>
            expense.userId == userId &&
            expense.date.isAfter(weekStart) &&
            expense.date.isBefore(weekEnd))
        .fold<double>(0, (sum, expense) => sum + expense.amount);
  }

  static Future<void> saveUser(UserModel user) async {
    final box = Hive.box<UserModel>(userBox);
    await box.put('currentUser', user);
  }

  static UserModel? getUser() {
    final box = Hive.box<UserModel>(userBox);
    return box.get('currentUser');
  }

  static Future<void> deleteUser() async {
    final box = Hive.box<UserModel>(userBox);
    await box.delete('currentUser');
  }

  static Future<void> addBadge(BadgeModel badge) async {
    final box = Hive.box<BadgeModel>(badgesBox);
    await box.put(badge.id, badge);
  }

  static List<BadgeModel> getUserBadges(String userId) {
    final box = Hive.box<BadgeModel>(badgesBox);
    return box.values.where((badge) => badge.userId == userId).toList();
  }

  static bool hasBadge(String userId, String badgeType) {
    final box = Hive.box<BadgeModel>(badgesBox);
    return box.values.any((badge) =>
        badge.userId == userId && badge.badgeType == badgeType);
  }

  static Future<void> clearAllData() async {
    final expenseBox = Hive.box<ExpenseModel>(expensesBox);
    final userBox = Hive.box<UserModel>(userBox);
    final badgesBox = Hive.box<BadgeModel>(badgesBox);

    await Future.wait([
      expenseBox.clear(),
      userBox.clear(),
      badgesBox.clear(),
    ]);
  }
}
