class PostModel {
  late String uId;
  late String username;
  late String image;
  late String dateTime;
  late String text;
  late String postImage;
  PostModel({
    required this.uId,
    required this.username,
    required this.image,
    required this.dateTime,
    required this.text,
    required this.postImage,
  });
  PostModel.fromJSON(Map<String, dynamic> json) {
    uId = json['uId'];
    username = json['username'];
    dateTime = json['dateTime'];
    text = json['text'];
    image = json['image'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'dateTime': dateTime,
      'text': text,
      'image': image,
      'postImage': postImage,
    };
  }
}
