class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final bool isBlocked;
  final String aadhaarNumber;
  final String panNumber;
  final String bloodGroup;
  final String? profilePicture;
  final String joinedAt;
  final String updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.isBlocked,
    required this.aadhaarNumber,
    required this.panNumber,
    required this.bloodGroup,
    required this.profilePicture,
    required this.joinedAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['user_id'] ?? '',
      name: json['name'] ?? 'No Name',
      email: json['email'] ?? '',
      phone: json['phoneNumber'] ?? '',
      isBlocked: json['isBlocked'] ?? false,
      aadhaarNumber: json['aadhaarNumber'] ?? '',
      panNumber: json['panNumber'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      profilePicture: json['profilePicture'],
      joinedAt: json['joinedAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': uid,
      'name': name,
      'email': email,
      'phoneNumber': phone,
      'isBlocked': isBlocked,
      'aadhaarNumber': aadhaarNumber,
      'panNumber': panNumber,
      'bloodGroup': bloodGroup,
      'profilePicture': profilePicture,
      'joinedAt': joinedAt,
      'updatedAt': updatedAt,
    };
  }
}