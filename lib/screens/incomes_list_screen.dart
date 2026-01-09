import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/edit_income_screen.dart';
import '../services/income_service.dart';
import '../models/income.dart';

class IncomesListScreen extends StatefulWidget {
  const IncomesListScreen({super.key});

  @override
  State<IncomesListScreen> createState() => _IncomesListScreenState();
}

class _IncomesListScreenState extends State<IncomesListScreen> {
  final IncomeService _incomeService = IncomeService();
  late Future<List<Income>> _incomesFuture;

  @override
  void initState() {
    super.initState();
    _loadIncomes();
  }

  void _loadIncomes() {
    _incomesFuture = _incomeService.getIncomes();
  }

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
      body: FutureBuilder<List<Income>>(
        future: _incomesFuture,
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
            return const Center(child: Text('No incomes yet 💰'));
          }

          final incomes = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(_loadIncomes);
            },
            child: ListView.builder(
              itemCount: incomes.length,
              itemBuilder: (context, index) {
                final income = incomes[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      income.source,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      income.date.toLocal().toString().split(' ')[0],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${income.amount.toStringAsFixed(2)} RSD',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.redAccent),
                          onPressed: () async {
                            final confirmed =
                                await _confirmDelete(context);
                            if (confirmed == true) {
                              await _incomeService
                                  .deleteIncome(income.id);

                              if (!mounted) return;

                              setState(_loadIncomes);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Income deleted'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditIncomeScreen(income: income),
                        ),
                      );

                      setState(_loadIncomes);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
