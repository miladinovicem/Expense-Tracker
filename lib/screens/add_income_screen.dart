import 'package:flutter/material.dart';
import '../services/income_service.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _amountController = TextEditingController();
  final _sourceController = TextEditingController();
  final IncomeService _incomeService = IncomeService();

  bool _isLoading = false;
  String _error = '';

  Future<void> _saveIncome() async {
    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null) {
      setState(() => _error = 'Invalid amount');
      return;
    }

    if (_sourceController.text.trim().isEmpty) {
      setState(() => _error = 'Source is required');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      await _incomeService.addIncome(
        amount: amount,
        source: _sourceController.text.trim(),
        date: DateTime.now(),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Income')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sourceController,
              decoration: const InputDecoration(labelText: 'Source'),
            ),
            const SizedBox(height: 20),

            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),

            ElevatedButton(
              onPressed: _isLoading ? null : _saveIncome,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
