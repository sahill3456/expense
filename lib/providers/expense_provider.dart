import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/database_service.dart';

class ExpenseProvider extends ChangeNotifier {
  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> _filteredExpenses = [];
  String? _selectedCategory;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  double? _minAmount;
  double? _maxAmount;
  String _searchQuery = '';

  List<ExpenseModel> get expenses => _filteredExpenses.isEmpty && _expenses.isNotEmpty
      ? _expenses
      : _filteredExpenses;
  String? get selectedCategory => _selectedCategory;
  DateTime? get selectedStartDate => _selectedStartDate;
  DateTime? get selectedEndDate => _selectedEndDate;
  double? get minAmount => _minAmount;
  double? get maxAmount => _maxAmount;
  String get searchQuery => _searchQuery;

  ExpenseProvider() {
    _loadExpenses();
  }

  void _loadExpenses({String? userId}) {
    if (userId != null) {
      _expenses = DatabaseService.getExpensesByUserId(userId);
    } else {
      _expenses = DatabaseService.getAllExpenses();
    }
    _applyFilters();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await DatabaseService.addExpense(expense);
    _expenses.add(expense);
    _applyFilters();
    notifyListeners();
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await DatabaseService.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    }
    _applyFilters();
    notifyListeners();
  }

  Future<void> deleteExpense(String expenseId) async {
    await DatabaseService.deleteExpense(expenseId);
    _expenses.removeWhere((e) => e.id == expenseId);
    _applyFilters();
    notifyListeners();
  }

  void setUserExpenses(String userId) {
    _loadExpenses(userId: userId);
    notifyListeners();
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void filterByDateRange(DateTime startDate, DateTime endDate) {
    _selectedStartDate = startDate;
    _selectedEndDate = endDate;
    _applyFilters();
    notifyListeners();
  }

  void filterByAmountRange(double minAmount, double maxAmount) {
    _minAmount = minAmount;
    _maxAmount = maxAmount;
    _applyFilters();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedStartDate = null;
    _selectedEndDate = null;
    _minAmount = null;
    _maxAmount = null;
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredExpenses = _expenses.where((expense) {
      // Category filter
      if (_selectedCategory != null && expense.category != _selectedCategory) {
        return false;
      }

      // Date range filter
      if (_selectedStartDate != null && _selectedEndDate != null) {
        if (expense.date.isBefore(_selectedStartDate!) ||
            expense.date.isAfter(_selectedEndDate!)) {
          return false;
        }
      }

      // Amount range filter
      if (_minAmount != null && expense.amount < _minAmount!) {
        return false;
      }
      if (_maxAmount != null && expense.amount > _maxAmount!) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!expense.description.toLowerCase().contains(query) &&
            !expense.category.toLowerCase().contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort by date (newest first)
    _filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
  }

  double getTotalExpenses(String userId) {
    return DatabaseService.getTotalExpenses(userId);
  }

  double getMonthlyExpenses(String userId, int month, int year) {
    return DatabaseService.getMonthlyExpenses(userId, month, year);
  }

  double getWeeklyExpenses(String userId, DateTime weekStart) {
    return DatabaseService.getWeeklyExpenses(userId, weekStart);
  }

  Map<String, double> getCategoryBreakdown(String userId) {
    final userExpenses =
        DatabaseService.getExpensesByUserId(userId);
    final categoryBreakdown = <String, double>{};

    for (final expense in userExpenses) {
      categoryBreakdown[expense.category] =
          (categoryBreakdown[expense.category] ?? 0) + expense.amount;
    }

    return categoryBreakdown;
  }

  List<ExpenseModel> getRecurringExpenses(String userId) {
    final userExpenses =
        DatabaseService.getExpensesByUserId(userId);
    return userExpenses.where((expense) => expense.isRecurring).toList();
  }
}
