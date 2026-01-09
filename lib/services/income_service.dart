import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/income.dart';

class IncomeService {
  static const String _baseUrl =
      'https://expensetracker-126ef-default-rtdb.europe-west1.firebasedatabase.app';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> _getToken() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  // CREATE
  Future<void> addIncome({
    required double amount,
    required String source,
    required DateTime date,
  }) async {
    final user = _auth.currentUser;
    final token = await _getToken();
    if (user == null || token == null) return;

    final url = Uri.parse(
      '$_baseUrl/users/${user.uid}/incomes.json?auth=$token',
    );

    await http.post(
      url,
      body: jsonEncode({
        'amount': amount,
        'source': source,
        'date': date.toIso8601String(),
      }),
    );
  }

  // READ
  Future<List<Income>> getIncomes() async {
    final user = _auth.currentUser;
    final token = await _getToken();
    if (user == null || token == null) return [];

    final url = Uri.parse(
      '$_baseUrl/users/${user.uid}/incomes.json?auth=$token',
    );

    final response = await http.get(url);

    if (response.body == 'null') return [];

    final Map<String, dynamic> data = jsonDecode(response.body);

    return data.entries.map((e) {
      return Income.fromMap(e.key, e.value);
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // UPDATE
  Future<void> updateIncome({
    required String id,
    required double amount,
    required String source,
    required DateTime date,
  }) async {
    final user = _auth.currentUser;
    final token = await _getToken();
    if (user == null || token == null) return;

    final url = Uri.parse(
      '$_baseUrl/users/${user.uid}/incomes/$id.json?auth=$token',
    );

    await http.patch(
      url,
      body: jsonEncode({
        'amount': amount,
        'source': source,
        'date': date.toIso8601String(),
      }),
    );
  }

  // DELETE
  Future<void> deleteIncome(String id) async {
    final user = _auth.currentUser;
    final token = await _getToken();
    if (user == null || token == null) return;

    final url = Uri.parse(
      '$_baseUrl/users/${user.uid}/incomes/$id.json?auth=$token',
    );

    await http.delete(url);
  }
}
