import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../models/expense_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/expense_provider.dart';
import 'add_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer2<AuthProvider, ExpenseProvider>(
        builder: (context, authProvider, expenseProvider, _) {
          final userId = authProvider.currentUser?.id;
          if (userId == null) {
            return const Center(child: Text('Please log in'));
          }

          final expenses = expenseProvider.expenses
              .where((e) => e.userId == userId)
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    expenseProvider.search(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search expenses...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              expenseProvider.search('');
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showFilterDialog(context, expenseProvider),
                        icon: const Icon(Icons.filter_list),
                        label: const Text('Filter'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => expenseProvider.clearFilters(),
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (expenses.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No expenses found'),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      return _buildExpenseItem(context, expenses[index]);
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildExpenseItem(BuildContext context, ExpenseModel expense) {
    final category = ExpenseCategory.fromString(expense.category);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddExpenseScreen(expense: expense),
          ),
        );
      },
      onLongPress: () => _showExpenseOptions(context, expense),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
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
                  child: Text(category.emoji, style: const TextStyle(fontSize: 24)),
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
                      '${category.displayName} • ${dateFormat.format(expense.date)}',
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
      ),
    );
  }

  void _showExpenseOptions(BuildContext context, ExpenseModel expense) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddExpenseScreen(expense: expense),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, expense);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ExpenseModel expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Expense?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ExpenseProvider>().deleteExpense(expense.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense deleted')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context, ExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return _FilterDialog(provider: provider);
      },
    );
  }
}

class _FilterDialog extends StatefulWidget {
  final ExpenseProvider provider;

  const _FilterDialog({required this.provider});

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late String? _selectedCategory;
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.provider.selectedCategory;
    _startDate = widget.provider.selectedStartDate;
    _endDate = widget.provider.selectedEndDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Expenses'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = null);
                  },
                ),
                ...ExpenseCategory.values.map((category) {
                  return FilterChip(
                    label: Text(category.displayName),
                    selected: _selectedCategory == category.name,
                    onSelected: (selected) {
                      setState(() =>
                          _selectedCategory = selected ? category.name : null);
                    },
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Date Range',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            // Add date range picker implementation
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_selectedCategory != null) {
              widget.provider.filterByCategory(_selectedCategory);
            }
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
