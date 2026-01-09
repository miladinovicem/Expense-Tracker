import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense.dart';

class ExpenseService {
  static const String _baseUrl =
      'https://expensetracker-126ef-default-rtdb.europe-west1.firebasedatabase.app';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> _getToken() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  // CREATE
  Future<void> addExpense({
    required double amount,
    required String category,
    required DateTime date,
  }) async {
    final user = _auth.currentUser;
    final token = await _getToken();
    if (user == null || token == null) return;

    final url = Uri.parse(
      '$_baseUrl/users/${user.uid}/expenses.json?auth=$token',
    );

    await http.post(
      url,
      body: jsonEncode({
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
      }),
    );
  }

  // READ
  Future<List<Expense>> getExpenses() async {
    final user = _auth.currentUser;
    final token = await _getToken();
    if (user == null || token == null) return [];

    final url = Uri.parse(
      '$_baseUrl/users/${user.uid}/expenses.json?auth=$token',
    );

    final response = await http.get(url);

    if (response.body == 'null') return [];

    final Map<String, dynamic> data = jsonDecode(response.body);

    return data.entries.map((e) {
      return Expense.fromMap(e.key, e.value);
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // UPDATE
  Future<void> updateExpense({
    required String id,
    required double amount,
    required String category,
    required DateTime date,
  }) async {
    final user = _auth.currentUser;
    final token = await _getToken();
    if (user == null || token == null) return;

    final url = Uri.parse(
      '$_baseUrl/users/${user.uid}/expenses/$id.json?auth=$token',
    );

    await http.patch(
      url,
      body: jsonEncode({
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
      }),
    );
  }

  // DELETE
  Future<void> deleteExpense(String id) async {
    final user = _auth.currentUser;
    final token = await _getToken();
    if (user == null || token == null) return;

    final url = Uri.parse(
      '$_baseUrl/users/${user.uid}/expenses/$id.json?auth=$token',
    );

    await http.delete(url);
  }
}
