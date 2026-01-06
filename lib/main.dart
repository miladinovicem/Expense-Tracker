import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// AUTH
import 'screens/auth_gate.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

// MAIN DASHBOARD
import 'screens/balance_screen.dart';

// EXPENSES
import 'screens/add_expense_screen.dart';
import 'screens/expenses_list_screen.dart';

// INCOMES
import 'screens/add_income_screen.dart';
import 'screens/incomes_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',

      /// 🔐 AUTH GATE odlučuje gde ide user
      home: const AuthGate(),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        /// 🟤 GLAVNI HOME (BALANCE)
        '/balance': (context) => const BalanceScreen(),

        /// EXPENSES
        '/add-expense': (context) => const AddExpenseScreen(),
        '/expenses': (context) => ExpensesListScreen(),

        /// INCOMES
        '/add-income': (context) => const AddIncomeScreen(),
        '/incomes': (context) => IncomesListScreen(),
      },
    );
  }
}
