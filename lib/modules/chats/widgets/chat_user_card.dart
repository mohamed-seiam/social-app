import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/modules/chats/widgets/profile_dialog.dart';
import 'package:chatapp/network/remote/apis.dart';
import 'package:chatapp/network/remote/helper.dart';
import 'package:flutter/material.dart';

import '../../../animation/size_transition4.dart';
import '../../../models/message_model.dart';
import '../../chat_details/chat_details.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({Key? key, required this.socialUserModel})
      : super(key: key);
  final SocialUserModel socialUserModel;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  SocialMessageModel? message;
  List<SocialMessageModel> _list = [];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            SizeTransition4(
              ChatDetailsScreen(
                userModel: widget.socialUserModel,
              ),
            ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2,
        color: Colors.white60.withOpacity(.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: StreamBuilder(
            stream: Api.getLastMessage(userModel: widget.socialUserModel),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              _list = data
                      ?.map((e) => SocialMessageModel.fromJson(e.data()))
                      .toList() ??
                  [];
              if (_list.isNotEmpty) message = _list.last;
              return ListTile(
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ProfileDialog(
                          userModel: widget.socialUserModel,
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 27,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.socialUserModel.image,
                          //  maxWidth:20,
                          // maxHeight:20,
                          // scale: 100,
                          // errorListener: (object) =>
                          // const CircularProgressIndicator(),
                      ),
                    )
                  ),
                  title: Text(
                    widget.socialUserModel.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, height: 2.5),
                  ),
                  subtitle: Text(
                      message != null
                          ? message!.type == Type.image
                              ? 'image'
                              : message!.text
                          : 'Hello Iam using We Chat',
                      maxLines: 1),
                  trailing: message == null
                      ? null
                      : message!.read.isNotEmpty &&
                              message!.fromId != Api.user!.uid
                          ? Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(child: Text(_list.length.toString())),
                            )
                          : Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: message!.sent),
                              style: const TextStyle(color: Colors.black54),
                            ));
            },
          ),
        ),
      ),
    );
  }
}
