class UserCashbackModel {
  final String rewardId;
  final String type;
  final String coins;
  final String transactionId;
  final String? refUser;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserCashbackModel({
    required this.rewardId,
    required this.type,
    required this.coins,
    required this.transactionId,
    this.refUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserCashbackModel.fromJson(Map<String, dynamic> json) {
    return UserCashbackModel(
      rewardId: json['reward_id'] ?? '',
      type: json['type'] ?? '',
      coins: json['coins'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      refUser: json['refUser'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reward_id': rewardId,
      'type': type,
      'coins': coins,
      'transaction_id': transactionId,
      'refUser': refUser,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
