class ChannelPartnerModel {
  final String channelPartnerId;
  final String name;
  final String userName;
  final String password;
  final String phone;
  final String email;
  final String district;
  final String idProofFront;
  final String idProofBack;
  final String profilePicture;
  final bool isBlocked;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChannelPartnerModel({
    required this.channelPartnerId,
    required this.name,
    required this.userName,
    required this.password,
    required this.phone,
    required this.email,
    required this.district,
    required this.idProofFront,
    required this.idProofBack,
    required this.profilePicture,
    required this.isBlocked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChannelPartnerModel.fromJson(Map<String, dynamic> json) {
    return ChannelPartnerModel(
      channelPartnerId: json['channel_partner_id'] as String,
      name: json['name'] as String,
      userName: json['userName'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      district: json['district'] as String,
      idProofFront: json['idProofFront'] as String,
      idProofBack: json['idProofBack'] as String,
      profilePicture: json['profilePicture'] as String,
      isBlocked: json['isBlocked'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}