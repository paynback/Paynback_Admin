class Merchant {
  final String? merchantId;
  final String? name;
  final String? email;
  final String? phone;
  final String? shopName;
  final String? category;
  final String? aadhaarNumber;
  final String? aadhaarFront;
  final String? aadhaarBack;
  final String? panNumber;
  final String? panImage;
  final String? bankAccountNumber;
  final String? bankName;
  final String? ifscCode;
  final String? profilePicture;
  final List<String> shopPictures;
  final String? qrCodeId;
  final bool isKyc;
  final bool isBlocked;
  final bool isVerified;
  final Map<String, dynamic>? location;

  Merchant({
    this.merchantId,
    this.name,
    this.email,
    this.phone,
    this.shopName,
    this.category,
    this.aadhaarNumber,
    this.aadhaarFront,
    this.aadhaarBack,
    this.panNumber,
    this.panImage,
    this.bankAccountNumber,
    this.bankName,
    this.ifscCode,
    this.profilePicture,
    this.shopPictures = const [],
    this.qrCodeId,
    this.isKyc = false,
    this.isBlocked = false,
    this.isVerified = false,
    this.location,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      merchantId: json['merchant_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      shopName: json['shopName'] as String?,
      category: json['category'] as String?,
      aadhaarNumber: json['aadhaarNumber'] as String?,
      aadhaarFront: json['aadhaarFront']?.toString(),
      aadhaarBack: json['aadhaarBack'] as String?,
      panNumber: json['panNumber'] as String?,
      panImage: json['panImage'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      bankName: json['bankName'] as String?,
      ifscCode: json['ifscCode'] as String?,
      profilePicture: json['profilePicture'] as String?,
      shopPictures:
          (json['shopPictures'] as List?)?.map((e) => e.toString()).toList() ??
              [],
      qrCodeId: json['qrCodeId'] as String?,
      isKyc: json['isKyc'] == true,
      isBlocked: json['isBlocked'] == true,
      isVerified: json['isVerified'] == true,
      location: json['location'] as Map<String, dynamic>?,
    );
  }
}
