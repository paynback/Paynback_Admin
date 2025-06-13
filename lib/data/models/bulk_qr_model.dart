class QrCodeModel {
  final String qrId;
  final String qrCode;
  final String merchantId;
  final bool isAssigned;
  final bool isDownloaded;
  final String createdAt;
  final String updatedAt;

  QrCodeModel({
    required this.qrId,
    required this.qrCode,
    required this.merchantId,
    required this.isAssigned,
    required this.isDownloaded,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QrCodeModel.fromJson(Map<String, dynamic> json) {
    try {
      return QrCodeModel(
        qrId: json['qr_id'] ?? '', // Note: API uses 'qr_id', not 'qrId'
        qrCode: json['qrCode'] ?? '',
        merchantId: json['merchantId'] ?? '',
        isAssigned: json['isAssigned'] ?? false,
        isDownloaded: json['isDownloaded'] ?? false,
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
      );
    } catch (e) {
      print("Error in QrCodeModel.fromJson: $e");
      print("JSON data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'qr_id': qrId,
      'qrCode': qrCode,
      'merchantId': merchantId,
      'isAssigned': isAssigned,
      'isDownloaded': isDownloaded,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
