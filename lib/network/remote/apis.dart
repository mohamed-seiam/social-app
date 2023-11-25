import 'dart:developer' as dev;
import 'dart:io';
import 'package:chatapp/notification_handelr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';

class Api {
  static final user = FirebaseAuth.instance.currentUser;
  static final fireStore = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance;
  static late final SocialUserModel me;
  static final messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  /// to get the device Token to can Send Notification
  static Future<void> getFirebaseMessagingToken(
      {required SocialUserModel userModel}) async {
    await messaging.requestPermission(
      announcement: true,
    );
    await messaging.getToken().then((value) {
      if (value != null) {
        userModel.pushToken = value;
        dev.log(userModel.pushToken!);
      }
    });
  }

  /// to get userSelf Info
  static Future<void> getSelfInfo() async {
    await fireStore
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) async {
      me = SocialUserModel.fromJson(value.data()!);
      await getFirebaseMessagingToken(userModel: me);
      Api.updateActiveStatus(
        isOnline: true,
      );
    });
  }

  /// to get the specific Id for each Conversation
  static String getConversationId(String id) =>
      user!.uid.hashCode <= id.hashCode
          ? '${user!.uid}_$id'
          : '${id}_${user!.uid}';
  static SocialUserModel? model;

  /// to update Chat read status {seen or not }
  static Future<void> updateMessageReadStatus(
      SocialMessageModel message) async {
    fireStore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({
      'read': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  /// to get realTime messages of Chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      {required SocialUserModel userModel}) {
    return fireStore
        .collection('chats/${getConversationId(userModel.uId)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  /// to send chat message
  static Future<void> sendMessage(
      {required SocialUserModel userModel,
      required String msg,
      required Type type}) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final SocialMessageModel message = SocialMessageModel(
        dateTime: DateTime.now().toString(),
        text: msg,
        toId: userModel.uId,
        fromId: user!.uid,
        type: type,
        read: '',
        sent: time);
    final ref = fireStore
        .collection('chats/${getConversationId(userModel.uId)}/messages/');
    await ref.doc(time).set(message.toMap()).then((value) {
      NotificationHandelr.sendPushNotification(
          userModel: userModel,
          msg: type == Type.text ? msg : 'photo',
          name: me.name);
    });
  }

  /// to get last Message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      {required SocialUserModel userModel}) {
    return fireStore
        .collection('chats/${getConversationId(userModel.uId)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  /// to send chat Image
  static Future<void> sendChatImage(
      {required SocialUserModel socialUserModel, required File file}) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'images/${getConversationId(socialUserModel.uId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    final imageUrl = await ref.getDownloadURL();
    Api.sendMessage(
        userModel: socialUserModel, msg: imageUrl, type: Type.image);
  }

  ///to get user info and storing deviceToken
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      {required SocialUserModel userModel}) {
    return fireStore
        .collection('users')
        .where('uId', isEqualTo: userModel.uId)
        .snapshots();
  }

  /// to update active and not active status
  static Future<void> updateActiveStatus({
    required bool isOnline,
  }) async {
    fireStore.collection('users').doc(user!.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  /// to Delete the Message
  static Future<void> deleteMessage(
      {required SocialMessageModel messageModel}) async {
    await fireStore
        .collection('chats/${getConversationId(messageModel.toId)}/messages/')
        .doc(messageModel.sent)
        .delete();
    if (messageModel.type == Type.image) {
      await storage.refFromURL(messageModel.text).delete();
    }
  }

  /// to Update the Message
  static Future<void> updateMessage(
      {required SocialMessageModel messageModel,
      required String updatedMsg}) async {
    await fireStore
        .collection('chats/${getConversationId(messageModel.toId)}/messages/')
        .doc(messageModel.sent)
        .update({
      'text': updatedMsg,
    });
  }
}
