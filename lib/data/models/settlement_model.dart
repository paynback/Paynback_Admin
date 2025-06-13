class SettlementModel {
  final String settlementId;
  final String merchantId;
  final String amount;
  final String totalAmount;
  final String merchantFee;
  final String gst;
  final String date;
  final String status;

  SettlementModel({
    required this.settlementId,
    required this.merchantId,
    required this.amount,
    required this.totalAmount,
    required this.merchantFee,
    required this.gst,
    required this.date,
    required this.status,
  });

  factory SettlementModel.fromJson(Map<String, dynamic> json) {
    return SettlementModel(
      settlementId: json['settlement_id'],
      merchantId: json['merchant_id'],
      amount: json['amount'],
      totalAmount: json['total_amount'],
      merchantFee: json['merchant_fee'],
      gst: json['gst'],
      date: json['date'],
      status: json['status'],
    );
  }
}
