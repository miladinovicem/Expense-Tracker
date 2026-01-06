import 'package:flutter/material.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';
import 'edit_expense_screen.dart';

class ExpensesListScreen extends StatelessWidget {
  ExpensesListScreen({super.key});

  final ExpenseService _expenseService = ExpenseService();

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Expenses')),
      body: StreamBuilder<List<Expense>>(
        stream: _expenseService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses yet 💸'));
          }

          final expenses = snapshot.data!;

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  /// 📌 CATEGORY
                  title: Text(
                    expense.category,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  /// 📅 DATE
                  subtitle: Text(
                    expense.date.toLocal().toString().split(' ')[0],
                  ),

                  /// 💰 AMOUNT + DELETE
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${expense.amount.toStringAsFixed(2)} RSD',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          final confirmed = await _confirmDelete(context);
                          if (confirmed == true) {
                            await _expenseService.deleteExpense(expense.id);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Expense deleted'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),

                  /// ✏️ EDIT ON TAP
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditExpenseScreen(expense: expense),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
