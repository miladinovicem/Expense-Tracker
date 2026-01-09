class Income {
  final String id;
  final double amount;
  final String source;
  final DateTime date;

  Income({
    required this.id,
    required this.amount,
    required this.source,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'source': source,
      'date': date.toIso8601String(),
    };
  }

  factory Income.fromMap(String id, Map<String, dynamic> map) {
    return Income(
      id: id,
      amount: (map['amount'] as num).toDouble(),
      source: map['source'] as String,
      date: DateTime.parse(map['date']),
    );
  }
}
