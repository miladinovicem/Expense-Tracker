import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
    };
  }

  factory Expense.fromMap(String id, Map<String, dynamic> map) {
    return Expense(
      id: id,
      userId: map['userId'],
      amount: (map['amount'] as num).toDouble(),
      category: map['category'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
