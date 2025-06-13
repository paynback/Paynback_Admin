class CommissionMerchantModel {
  final String merchantId;
  final String shopName;
  final String commission;

  CommissionMerchantModel({
    required this.merchantId,
    required this.shopName,
    required this.commission,
  });

  factory CommissionMerchantModel.fromJson(Map<String, dynamic> json) {
    return CommissionMerchantModel(
      merchantId: json['merchant_id'] ?? '',
      shopName: json['shopName'] ?? 'Unknown Shop',
      commission: json['commission'] ?? '0',
    );
  }
}