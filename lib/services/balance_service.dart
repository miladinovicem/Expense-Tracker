import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BalanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<double> getTotalExpenses() async {
    final user = _auth.currentUser;
    if (user == null) return 0.0;

    final snapshot = await _db
        .collection('expenses')
        .where('userId', isEqualTo: user.uid)
        .get();

    return snapshot.docs.fold<double>(
      0.0,
      (sum, doc) => sum + (doc['amount'] as num).toDouble(),
    );
  }

  Future<double> getTotalIncome() async {
    final user = _auth.currentUser;
    if (user == null) return 0.0;

    final snapshot = await _db
        .collection('incomes')
        .where('userId', isEqualTo: user.uid)
        .get();

    return snapshot.docs.fold<double>(
      0.0,
      (sum, doc) => sum + (doc['amount'] as num).toDouble(),
    );
  }
}
