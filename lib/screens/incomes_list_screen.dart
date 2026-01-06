import 'package:flutter/material.dart';
import '../services/income_service.dart';
import '../models/income.dart';

class IncomesListScreen extends StatelessWidget {
  IncomesListScreen({super.key});

  final IncomeService _incomeService = IncomeService();

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete income'),
        content: const Text('Are you sure you want to delete this income?'),
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
      appBar: AppBar(title: const Text('My Incomes')),
      body: StreamBuilder<List<Income>>(
        stream: _incomeService.getIncomes(),
        builder: (context, snapshot) {
          // ⏳ loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // 📭 empty
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No incomes yet 💰'));
          }

          final incomes = snapshot.data!;

          return ListView.builder(
            itemCount: incomes.length,
            itemBuilder: (context, index) {
              final income = incomes[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(income.source),
                  subtitle: Text(
                    income.date.toLocal().toString().split(' ')[0],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await _confirmDelete(context);
                      if (confirmed == true) {
                        await _incomeService.deleteIncome(income.id);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Income deleted')),
                          );
                        }
                      }
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
