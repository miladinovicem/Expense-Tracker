import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('View expenses'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/expenses');
              },
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add expense'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/add-expense');
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/incomes');
              },
              child: const Text('View incomes'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-income');
              },
              child: const Text('Add income'),
            ),
          ],
        ),
      ),
    );
  }
}
