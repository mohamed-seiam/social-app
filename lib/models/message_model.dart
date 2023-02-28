import 'package:cloud_firestore/cloud_firestore.dart';

class SocialMessageModel
{
  String ? text;
  String ? dateTime;
  String ? receiverId ;
  String ? senderId ;

  SocialMessageModel({

    this.dateTime,
    this.text,
    this.receiverId,
    this.senderId,
  });

  SocialMessageModel.fromjson(Map<String,dynamic>?json)
  {
    dateTime = json? ['dateTime'];
    text = json?['text'];
    receiverId = json?['receiverId'];
    senderId = json?['senderId'];
  }

  Map<String,dynamic> tomap()
  {
    return
      {
        'receiverId' : receiverId,
        'dateTime' : dateTime,
        'senderId' : senderId,
        'text':text,
      };
  }
}