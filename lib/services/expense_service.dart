import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE
  Future<void> addExpense({
    required double amount,
    required String category,
    required DateTime date,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('expenses').add({
      'userId': user.uid,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // UPDATE
  Future<void> updateExpense({
    required String id,
    required double amount,
    required String category,
    required DateTime date,
  }) async {
    await _db.collection('expenses').doc(id).update({
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
    });
  }

  // READ
  Stream<List<Expense>> getExpenses() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('expenses')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Expense.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // DELETE
  Future<void> deleteExpense(String id) async {
    await _db.collection('expenses').doc(id).delete();
  }
}
