class UserTransactionModel {
  final String transactionId;
  final String amount;
  final String type;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserTransactionModel({
    required this.transactionId,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserTransactionModel.fromJson(Map<String, dynamic> json) {
    return UserTransactionModel(
      transactionId: json['transaction_id'] ?? '',
      amount: json['amount'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'amount': amount,
      'type': type,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}