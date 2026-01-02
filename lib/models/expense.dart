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
      'date': date,
    };
  }

  factory Expense.fromMap(String id, Map<String, dynamic> map) {
    return Expense(
      id: id,
      userId: map['userId'],
      amount: map['amount'],
      category: map['category'],
      date: map['date'].toDate(),
    );
  }
}
