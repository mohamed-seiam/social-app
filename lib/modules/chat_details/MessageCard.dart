import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/network/remote/apis.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:chatapp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../network/remote/helper.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.messageModel}) : super(key: key);
  final SocialMessageModel messageModel;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = Api.user!.uid == widget.messageModel.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe: isMe);
      },
      child: isMe ? whiteMessage() : greyMessage(),
    );
  }

  Widget greyMessage() {
    if (widget.messageModel.read.isEmpty) {
      Api.updateMessageReadStatus(widget.messageModel);
    }
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(widget.messageModel.type == Type.text
                  ? MediaQuery.of(context).size.width * .04
                  : 0),
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .04,
                  vertical: 5),
              decoration: BoxDecoration(
                  // border: Border.all(color: Colors.lightGreen),
                  color: Colors.grey[300],
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(30),
                    topEnd: Radius.circular(30),
                    topStart: Radius.circular(30),
                  )),
              child: widget.messageModel.type == Type.text
                  ? Text(
                      widget.messageModel.text,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadiusDirectional.only(
                        bottomEnd: Radius.circular(30),
                        topEnd: Radius.circular(30),
                        topStart: Radius.circular(30),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.messageModel.text,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
            ),
          ],
        ),
        Row(
          children: [
            if (widget.messageModel.read.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: const Icon(
                  Icons.done_all_rounded,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.messageModel.sent),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget whiteMessage() {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.end,
      direction: Axis.vertical,
      children: [
        Column(children: [
          Container(
            padding: EdgeInsets.all(widget.messageModel.type == Type.text
                ? MediaQuery.of(context).size.width * .04
                : 0),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
                vertical: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(30),
                  topEnd: Radius.circular(30),
                  topStart: Radius.circular(30),
                )),
            child: widget.messageModel.type == Type.text
                ? Text(
                    widget.messageModel.text,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(30),
                      topEnd: Radius.circular(30),
                      topStart: Radius.circular(30),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.messageModel.text,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.messageModel.sent),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
            if (widget.messageModel.read.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: const Icon(
                  Icons.done_all_rounded,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
          ],
        )
      ],
    );
  }

  void _showBottomSheet({required bool isMe}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      builder: (context) {
        final mq = MediaQuery.of(context).size;
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                  vertical: mq.height * .015, horizontal: mq.width * .4),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // SizedBox(
            //   height: mq.height * .02,
            // ),
            widget.messageModel.type == Type.text
                ? OptionItem(
                    name: 'Copy Text',
                    icon: const Icon(
                      Icons.copy_all_rounded,
                      color: defaultColor,
                      size: 26,
                    ),
                    onTap: () async {
                      print('hhhhhhhhhhhhhh');
                      await Clipboard.setData(
                              ClipboardData(text: widget.messageModel.text))
                          .then((value) {
                        Navigator.pop(context);
                        showCustomSnackBar(
                            context: context, msg: 'Text Copied!');
                      });
                    },
                  )
                : OptionItem(
                    name: 'Save Image',
                    icon: const Icon(
                      Icons.save_alt_outlined,
                      color: defaultColor,
                      size: 26,
                    ),
                    onTap: () async {
                      await saveImage(context: context).then((value) {
                        Navigator.pop(context);
                      });
                    },
                  ),
            Divider(
              color: Colors.black54,
              endIndent: mq.width * .04,
              indent: mq.width * .04,
            ),
            if (widget.messageModel.type == Type.text && isMe)
              OptionItem(
                name: 'Edit Message',
                icon: const Icon(
                  Icons.edit,
                  color: defaultColor,
                  size: 26,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showMessageUpdateDialog();
                },
              ),
            if (isMe)
              OptionItem(
                name: 'Delete Message',
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 26,
                ),
                onTap: () async {
                  await Api.deleteMessage(messageModel: widget.messageModel)
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
              ),
            if (isMe)
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
            OptionItem(
              name:
                  'Sent at :${MyDateUtil.getMessageTime(context: context, time: widget.messageModel.sent)}',
              icon: const Icon(
                Icons.send_outlined,
                color: defaultColor,
              ),
              onTap: () {},
            ),
            OptionItem(
              name: widget.messageModel.read.isNotEmpty
                  ? 'Read at :${MyDateUtil.getMessageTime(context: context, time: widget.messageModel.read)}'
                  : 'Read at : Not seen yet',
              icon: const Icon(
                Icons.remove_red_eye,
                color: Colors.green,
              ),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  Future<void> saveImage({required BuildContext context}) async {
    String? message;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final http.Response response =
          await http.get(Uri.parse(widget.messageModel.text));
      final dir = await getTemporaryDirectory();
      var fileName = '${dir.path}/image.png';
      final file = File(fileName);
      await file.writeAsBytes(response.bodyBytes);
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);
      if (finalPath != null) {
        message = 'Image Saved to Device';
      }
    } catch (error) {
      message = 'An error occurred while saving the image';
    }
    if (message != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  _showMessageUpdateDialog() {
    String updatedMsg = widget.messageModel.text;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.messenger_outline_outlined,
              color: Colors.blue,
              size: 28,
            ),
            Text('Update Message'),
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => updatedMsg = value,
          initialValue: updatedMsg,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              Navigator.pop(context);
              await Api.updateMessage(
                  messageModel: widget.messageModel, updatedMsg: updatedMsg);
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  const OptionItem(
      {Key? key, required this.icon, required this.name, required this.onTap})
      : super(key: key);
  final Icon icon;
  final String name;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: mq.width * .05,
          left: mq.width * .05,
          bottom: mq.height * .02,
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '    $name',
                style: const TextStyle(
                    fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
