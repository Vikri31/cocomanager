class TransactionModel {
  final int? id;
  final String type; // 'pembelian' or 'penjualan'
  final String category; // 'kelapa', 'batok kelapa', 'kulit kelapa'
  final int amount; // For kelapa (butir)
  final double weight; // For non-kelapa (kg)
  final int price; // Rp
  final String description; // Location or other info
  final DateTime date;

  TransactionModel({
    this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.weight,
    required this.price,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'amount': amount,
      'weight': weight,
      'price': price,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      category: map['category'],
      amount: map['amount'],
      weight: map['weight'],
      price: map['price'],
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }
}
