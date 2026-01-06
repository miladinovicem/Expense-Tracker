import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pie_chart/pie_chart.dart';

import '../services/balance_service.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final BalanceService _balanceService = BalanceService();

  double _income = 0;
  double _expenses = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final income = await _balanceService.getTotalIncome();
    final expenses = await _balanceService.getTotalExpenses();

    setState(() {
      _income = income;
      _expenses = expenses;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double remaining = (_income - _expenses)
        .clamp(0, double.infinity)
        .toDouble();

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Balance'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),

      /// ✅ FIX: SCROLL
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔵 DONUT CHART
              PieChart(
                dataMap: {'Expenses': _expenses, 'Remaining': remaining},
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                colorList: const [
                  Color(0xFFD7CCC8), // expenses
                  Color(0xFF6D4C41), // remaining
                ],
                legendOptions: LegendOptions(
                  legendPosition: LegendPosition.bottom,
                  legendLabels: {
                    'Expenses':
                        'Expenses – ${_expenses.toStringAsFixed(2)} RSD',
                    'Remaining':
                        'Remaining – ${remaining.toStringAsFixed(2)} RSD',
                  },
                ),
                centerWidget: _AnimatedCenterAmount(amount: remaining),
              ),

              const SizedBox(height: 32),

              /// 🔘 ACTION BUTTONS
              _ActionButton(
                icon: Icons.add,
                text: 'Add Expense',
                onTap: () => Navigator.pushNamed(context, '/add-expense'),
              ),
              _ActionButton(
                icon: Icons.list,
                text: 'View Expenses',
                onTap: () => Navigator.pushNamed(context, '/expenses'),
              ),
              _ActionButton(
                icon: Icons.add_circle_outline,
                text: 'Add Income',
                onTap: () => Navigator.pushNamed(context, '/add-income'),
              ),
              _ActionButton(
                icon: Icons.account_balance_wallet,
                text: 'View Incomes',
                onTap: () => Navigator.pushNamed(context, '/incomes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔢 ANIMATED CENTER NUMBER
class _AnimatedCenterAmount extends StatelessWidget {
  final double amount;

  const _AnimatedCenterAmount({required this.amount});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: amount),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text('RSD left', style: TextStyle(fontSize: 14)),
          ],
        );
      },
    );
  }
}

/// ♻️ REUSABLE BUTTON
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
        onPressed: onTap,
      ),
    );
  }
}
