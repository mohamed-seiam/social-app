class SocialUserModel {
  late final String email;
  late final String phone;
  late final String name;
  late final String uId;
  late final bool isEmailVerified;
  late final String image;
  late final String cover;
  late final String bio;
  late final String ? lastActive;
  late final bool? isOnline;
  late String ? pushToken;
  late final String createdAt;
  SocialUserModel({
    required this.email,
    required this.phone,
    required this.name,
    required this.uId,
    required this.isEmailVerified,
    required this.cover,
    required this.image,
    required this.bio,
    required this.createdAt,
     this.isOnline,
     this.lastActive,
     this.pushToken,
  });

  SocialUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
    cover = json['cover'];
    image = json['image'];
    bio = json['bio'];
    isOnline = json['is_online']??false;
    lastActive = json['last_active']??'';
    pushToken = json['push_token'];
    createdAt = json['created_At'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'uId': uId,
      'isEmailVerified': isEmailVerified,
      'cover': cover,
      'image': image,
      'bio': bio,
      'is_online': isOnline,
      'last_active': lastActive,
      'push_token': pushToken,
      'created_At':createdAt,
    };
  }
}
