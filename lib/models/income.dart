import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  final String id;
  final String userId;
  final double amount;
  final String source;
  final DateTime date;

  Income({
    required this.id,
    required this.userId,
    required this.amount,
    required this.source,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'source': source,
      'date': Timestamp.fromDate(date),
    };
  }

  factory Income.fromMap(String id, Map<String, dynamic> map) {
    return Income(
      id: id,
      userId: map['userId'],
      amount: (map['amount'] as num).toDouble(),
      source: map['source'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
