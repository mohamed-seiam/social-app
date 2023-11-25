

class SocialMessageModel {
  late final String text;
  late final String dateTime;
  late final String toId;
  late final String fromId;

  late final String sent;
  late final String read;
  late final Type type;

  SocialMessageModel({
    required this.dateTime,
    required this.text,
    required this.toId,
    required this.fromId,
    required this.type,
    required this.read,
    required this.sent,
  });

  SocialMessageModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    text = json['text'];
    toId = json['receiverId'];
    fromId = json['senderId'];
    read = json['read'];
    sent = json['sent'];
    type = json['type'] == Type.image.name ? Type.image : Type.text;
  }

  Map<String, dynamic> toMap() {
    return {
      'receiverId': toId,
      'dateTime': dateTime,
      'senderId': fromId,
      'text': text,
      'read': read,
      'sent': sent,
      'type': type.name,
    };
  }
}

enum Type { text, image }
