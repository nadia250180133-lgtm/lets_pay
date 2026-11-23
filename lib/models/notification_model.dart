import 'dart:convert';

enum NotificationCategory {
  transaksi,
  promo,
  sholat,
}

enum TransactionType {
  ewallet,
  pln,
  qris,
  pulsa,
  paketData,
  transferBank,
  transferBca,
  virtualAccount,
  lainnya,
}

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final NotificationCategory category;
  final TransactionType? transactionType;
  final double? amount;
  final String? recipient;
  final DateTime timestamp;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.transactionType,
    this.amount,
    this.recipient,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    NotificationCategory? category,
    TransactionType? transactionType,
    double? amount,
    String? recipient,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      recipient: recipient ?? this.recipient,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'transactionType': transactionType?.name,
      'amount': amount,
      'recipient': recipient,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: NotificationCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => NotificationCategory.transaksi,
      ),
      transactionType: map['transactionType'] != null
          ? TransactionType.values.firstWhere(
              (e) => e.name == map['transactionType'],
              orElse: () => TransactionType.lainnya,
            )
          : null,
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : null,
      recipient: map['recipient'],
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationItem.fromJson(String source) =>
      NotificationItem.fromMap(json.decode(source));
}