import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addExpense(double amount, String category, DateTime date) async {
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

  Stream<List<Expense>> getExpenses() {
    final user = _auth.currentUser;

    if (user == null) {
      // dok se auth ne inicijalizuje
      return const Stream.empty();
    }

    return _db
        .collection('expenses')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Expense.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> deleteExpense(String id) async {
    await _db.collection('expenses').doc(id).delete();
  }
}
