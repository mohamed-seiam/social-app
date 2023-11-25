import 'dart:async';
import 'dart:io';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/network/remote/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'MessageCard.dart';
import 'custom_appbar.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({super.key, required this.userModel});

  final SocialUserModel userModel;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  ScrollController scrollController = ScrollController();
  var messageController = TextEditingController();
  bool showEmoji = false;
  bool isUploading = false;
  List<SocialMessageModel> _list = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _messageSubscription;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? data;

  @override
  void initState() {
    _messageSubscription = Api.getAllMessages(userModel: widget.userModel)
        .listen((QuerySnapshot<Map<String, dynamic>> snapshots) {
          data = snapshots.docs;
    },);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (showEmoji) {
              setState(() {
                showEmoji = !showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: CustomAppBar(userModel:widget.userModel,),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: Api.getAllMessages(userModel: widget.userModel),
                    builder: (context, snapshots) {
                      switch (snapshots.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.done:
                          // final data = snapshots.data?.docs;
                          _list = data
                                  ?.map((e) =>
                                      SocialMessageModel.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * .01),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  messageModel: _list[index],
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hii!...👋',
                                style: TextStyle(fontSize: 22),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                if (isUploading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                chatInput(messageController: messageController),
                if (showEmoji)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: EmojiPicker(
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                        // Set it to null to hide the Backspace-Button
                      },
                      textEditingController: messageController,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        // Needs to be const Widget
                        loadingIndicator: const SizedBox.shrink(),
                        // Needs to be const Widget
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatInput({required TextEditingController messageController}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .01,
          horizontal: MediaQuery.of(context).size.width * .02),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                      color: Colors.black54.withOpacity(0.3), width: 1)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        showEmoji = !showEmoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      maxLines: 7,
                      scrollPhysics:const BouncingScrollPhysics(),
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      onTap: () {
                        if (showEmoji) {
                          setState(() {
                            showEmoji = !showEmoji;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * .02,
                  // ),
                ],
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final List<XFile> images =
              await picker.pickMultiImage(imageQuality: 80);
              for (var image in images) {
                setState(() {
                  isUploading = true;
                });
                await Api.sendChatImage(
                    socialUserModel: widget.userModel,
                    file: File(image.path));
                setState(() {
                  isUploading = false;
                });
              }
            },
            icon: const Icon(
              Icons.image,
              color: Colors.blueAccent,
              size: 25,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(
                  source: ImageSource.camera, imageQuality: 80);
              if (image != null) {
                setState(() {
                  isUploading = true;
                });
                await Api.sendChatImage(
                    socialUserModel: widget.userModel,
                    file: File(image.path));
                setState(() {
                  isUploading = false;
                });
              }
            },
            icon: const Icon(Icons.camera_alt_outlined,
                color: Colors.blueAccent, size: 25),
          ),
          MaterialButton(
            shape: const CircleBorder(),
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, right: 5, left: 10, bottom: 10),
            color: Colors.green,
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                Api.sendMessage(
                    userModel: widget.userModel,
                    msg: messageController.text,
                    type: Type.text);
                messageController.clear();
              } else {
                return;
              }
            },
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}


