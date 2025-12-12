import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../models/expense_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/expense_provider.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer2<AuthProvider, ExpenseProvider>(
        builder: (context, authProvider, expenseProvider, _) {
          final userId = authProvider.currentUser?.id;
          if (userId == null) {
            return const Center(child: Text('Please log in'));
          }

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton('Monthly', 0),
                    ),
                    Expanded(
                      child: _buildTabButton('Weekly', 1),
                    ),
                    Expanded(
                      child: _buildTabButton('Category', 2),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildTabContent(
                    context,
                    userId,
                    expenseProvider,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppTheme.primaryColor : null,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    String userId,
    ExpenseProvider provider,
  ) {
    switch (_selectedTab) {
      case 0:
        return _buildMonthlyView(context, userId, provider);
      case 1:
        return _buildWeeklyView(context, userId, provider);
      case 2:
        return _buildCategoryView(context, userId, provider);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMonthlyView(
    BuildContext context,
    String userId,
    ExpenseProvider provider,
  ) {
    final now = DateTime.now();
    final monthlyTotal = provider.getMonthlyExpenses(userId, now.month, now.year);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This Month',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${monthlyTotal.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 16),
              _buildMonthlyChart(context, userId, provider),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildMonthlyStats(context, userId, provider),
      ],
    );
  }

  Widget _buildMonthlyChart(
    BuildContext context,
    String userId,
    ExpenseProvider provider,
  ) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final expenses = provider.expenses.where((e) => e.userId == userId).toList();

    final dailyTotals = List<double>.filled(daysInMonth, 0);
    for (final expense in expenses) {
      if (expense.date.month == now.month && expense.date.year == now.year) {
        dailyTotals[expense.date.day - 1] += expense.amount;
      }
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt() + 1}',
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: dailyTotals.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value);
              }).toList(),
              isCurved: true,
              color: Colors.white,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyStats(
    BuildContext context,
    String userId,
    ExpenseProvider provider,
  ) {
    final expenses = provider.expenses.where((e) => e.userId == userId).toList();
    final now = DateTime.now();

    double highestDay = 0;
    double averagePerDay = 0;
    int daysWithExpenses = 0;

    final dailyTotals = <int, double>{};
    for (final expense in expenses) {
      if (expense.date.month == now.month && expense.date.year == now.year) {
        final day = expense.date.day;
        dailyTotals[day] = (dailyTotals[day] ?? 0) + expense.amount;
      }
    }

    if (dailyTotals.isNotEmpty) {
      highestDay = dailyTotals.values.reduce((a, b) => a > b ? a : b);
      daysWithExpenses = dailyTotals.length;
      averagePerDay = dailyTotals.values.reduce((a, b) => a + b) / daysWithExpenses;
    }

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Highest Day',
            '\$${highestDay.toStringAsFixed(2)}',
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Average/Day',
            '\$${averagePerDay.toStringAsFixed(2)}',
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyView(
    BuildContext context,
    String userId,
    ExpenseProvider provider,
  ) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weeklyTotal = provider.getWeeklyExpenses(userId, weekStart);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: AppGradients.secondaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This Week',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${weeklyTotal.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 16),
              _buildWeeklyChart(context, userId, provider, weekStart),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(
    BuildContext context,
    String userId,
    ExpenseProvider provider,
    DateTime weekStart,
  ) {
    final expenses = provider.expenses.where((e) => e.userId == userId).toList();
    final dayTotals = List<double>.filled(7, 0);
    const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (var i = 0; i < 7; i++) {
      final dayDate = weekStart.add(Duration(days: i));
      for (final expense in expenses) {
        if (expense.date.year == dayDate.year &&
            expense.date.month == dayDate.month &&
            expense.date.day == dayDate.day) {
          dayTotals[i] += expense.amount;
        }
      }
    }

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: dayTotals.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value,
                  color: AppTheme.primaryColor,
                  width: 16,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    daysOfWeek[value.toInt()],
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  Widget _buildCategoryView(
    BuildContext context,
    String userId,
    ExpenseProvider provider,
  ) {
    final categoryBreakdown = provider.getCategoryBreakdown(userId);

    if (categoryBreakdown.isEmpty) {
      return Center(
        child: Text(
          'No expenses yet',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final total =
        categoryBreakdown.values.reduce((a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: categoryBreakdown.entries.map((entry) {
                final category = ExpenseCategory.fromString(entry.key);
                final percentage = (entry.value / total * 100);
                return PieChartSectionData(
                  value: entry.value,
                  title: '${percentage.toStringAsFixed(1)}%',
                  radius: 100,
                  badgeWidget: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(category.emoji),
                  ),
                  badgePositionPercentageOffset: 1.2,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Breakdown',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...categoryBreakdown.entries.map((entry) {
          final category = ExpenseCategory.fromString(entry.key);
          final percentage = (entry.value / total * 100).toStringAsFixed(1);
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
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${entry.value.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '$percentage%',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
