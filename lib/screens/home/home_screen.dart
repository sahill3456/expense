import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/expense_provider.dart';
import '../../models/expense_model.dart';
import '../expenses/add_expense_screen.dart';
import '../expenses/expense_list_screen.dart';
import '../insights/insights_screen.dart';
import '../settings/settings_screen.dart';
import '../gamification/badges_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final authProvider = context.read<AuthProvider>();
    final expenseProvider = context.read<ExpenseProvider>();
    if (authProvider.currentUser != null) {
      expenseProvider.setUserExpenses(authProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavigation(),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 ? _buildFAB() : null,
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const _DashboardTab();
      case 1:
        return const ExpenseListScreen();
      case 2:
        return const InsightsScreen();
      case 3:
        return const BadgesScreen();
      case 4:
        return const SettingsScreen();
      default:
        return const _DashboardTab();
    }
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
        );
      },
      backgroundColor: AppTheme.primaryColor,
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: 'Badges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Consumer2<AuthProvider, ExpenseProvider>(
          builder: (context, authProvider, expenseProvider, _) {
            final user = authProvider.currentUser;
            if (user == null) {
              return const Center(
                child: Text('Please log in'),
              );
            }

            final userId = user.id;
            final monthlyExpenses =
                expenseProvider.getMonthlyExpenses(userId, DateTime.now().month, DateTime.now().year);
            final totalExpenses = expenseProvider.getTotalExpenses(userId);
            final categoryBreakdown = expenseProvider.getCategoryBreakdown(userId);
            final expenses = expenseProvider.expenses
                .where((e) => e.userId == userId)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreeting(context, user),
                const SizedBox(height: 24),
                _buildMonthlyCard(context, monthlyExpenses, user.monthlyBudget),
                const SizedBox(height: 24),
                _buildQuickStats(context, totalExpenses, expenses.length),
                const SizedBox(height: 24),
                _buildCategoryBreakdown(context, categoryBreakdown),
                const SizedBox(height: 24),
                _buildRecentExpenses(context, expenses),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, dynamic user) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            user.displayName ?? 'User',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyCard(BuildContext context, double spent, double budget) {
    final percentage = (spent / budget * 100).clamp(0, 100).toDouble();
    final remaining = budget - spent;
    final isOverBudget = spent > budget;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.primaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Spending',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${spent.toStringAsFixed(2)}',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                    Text(
                      'of \$${budget.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isOverBudget ? 'Over Budget' : 'Remaining',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    Text(
                      '\$${remaining.abs().toStringAsFixed(2)}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOverBudget ? Colors.red : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, double total, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Spent',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transactions',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    count.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context, Map<String, double> breakdown) {
    if (breakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending by Category',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...breakdown.entries.map((entry) {
            final percentage =
                (entry.value / breakdown.values.reduce((a, b) => a + b) * 100)
                    .toStringAsFixed(1);
            final category = ExpenseCategory.fromString(entry.key);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(category.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.displayName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: double.parse(percentage) / 100,
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '\$${entry.value.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecentExpenses(BuildContext context, List<ExpenseModel> expenses) {
    final recent = expenses.take(5).toList();

    if (recent.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Text(
              'No expenses yet',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking by adding your first expense!',
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Expenses',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...recent.map((expense) {
            final category = ExpenseCategory.fromString(expense.category);
            final dateFormat = DateFormat('MMM dd, yyyy');

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          category.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            dateFormat.format(expense.date),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '-\$${expense.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
