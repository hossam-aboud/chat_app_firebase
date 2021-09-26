class UserModel {
  late String uId;
  late String username;
  late String image;
  late String coverImage;
  late String email;
  late String bio;
  late String phone;
  late bool isEmailVerified;

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.phone,
    required this.image,
    required this.coverImage,
    required this.bio,
    required this.isEmailVerified,
  });
  UserModel.fromJSON(Map<String, dynamic> json) {
    uId = json['uId'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    coverImage = json['coverImage'];
    bio = json['bio'];

    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'phone': phone,
      'image': image,
      'coverImage': coverImage,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
