import 'package:flutter/material.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';

class ExpensesListScreen extends StatelessWidget {
  ExpensesListScreen({super.key});

  final ExpenseService _expenseService = ExpenseService();

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

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses yet'));
          }

          final expenses = snapshot.data!;

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    '${expense.category} - ${expense.amount.toStringAsFixed(2)}',
                  ),
                  subtitle: Text(
                    expense.date.toLocal().toString().split(' ')[0],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _expenseService.deleteExpense(expense.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
