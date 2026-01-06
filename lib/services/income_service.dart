import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/income.dart';

class IncomeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE
  Future<void> addIncome({
    required double amount,
    required String source,
    required DateTime date,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('incomes').add({
      'userId': user.uid,
      'amount': amount,
      'source': source,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // READ
  Stream<List<Income>> getIncomes() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('incomes')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Income.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  // DELETE
  Future<void> deleteIncome(String id) async {
    await _db.collection('incomes').doc(id).delete();
  }
}
