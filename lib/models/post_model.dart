import 'package:cloud_firestore/cloud_firestore.dart';

class SocialPostModel {
  String? name;
  String? uId;
  String? image;
  Timestamp? dateTime;
  String? postImage;
  String? text;
  String? postVideo;
  String ? type;
  int? totalComments;
  String? postId;
  List<String>? likes;
  int? totalLikes;

  SocialPostModel(
      {this.dateTime,
      this.postImage,
      this.totalLikes,
      this.postVideo,
      this.name,
      this.uId,
        this.type,
      this.text,
      this.image,
      this.totalComments,
      this.likes,
      this.postId});

  SocialPostModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    text = json['text'];
    name = json['name'];
    postVideo = json['video'];
    uId = json['uId'];
    type = json['type'];
    totalLikes = json['totalLikes'];
    postImage = json['postImage'];
    image = json['image'];
    totalComments = json['totalComments'];
    postId = json['postId'];
    likes = List.from(json['likes']);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateTime': dateTime,
      'uId': uId,
      'text': text,
      'postImage': postImage,
      'image': image,
      'totalComments': totalComments,
      'postId': postId,
      'totalLikes': totalLikes,
      'likes': likes,
      'video' : postVideo,
      'type':type,
    };
  }
}
