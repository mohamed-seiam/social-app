//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../models/user_model.dart';
// import '../../network/remote/apis.dart';
//
// class ChatInput extends StatefulWidget {
//   const ChatInput({Key? key, required this.messageController, required this.userModel,}) : super(key: key);
//   final TextEditingController messageController;
//   final SocialUserModel userModel;
//   @override
//   State<ChatInput> createState() => _ChatInputState();
// }
// class _ChatInputState extends State<ChatInput> {
//   bool showEmoji = false;
//   bool isUploading = false;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           vertical: MediaQuery.of(context).size.height * .01,
//           horizontal: MediaQuery.of(context).size.width * .011),
//       child: Row(
//         children: [
//           Expanded(
//             child: Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   side: BorderSide(
//                       color: Colors.black54.withOpacity(0.3), width: 1)),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       FocusScope.of(context).unfocus();
//                       setState(() {
//                         showEmoji = !showEmoji;
//                       });
//                     },
//                     icon: const Icon(
//                       Icons.emoji_emotions_outlined,
//                       color: Colors.blueAccent,
//                       size: 26,
//                     ),
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: widget.messageController,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       onTap: () {
//                         if (showEmoji) {
//                           setState(() {
//                             showEmoji = !showEmoji;
//                           });
//                         }
//                       },
//                       decoration: const InputDecoration(
//                         hintText: 'Type Something...',
//                         hintStyle: TextStyle(
//                           color: Colors.blueAccent,
//                         ),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () async {
//                       final ImagePicker picker = ImagePicker();
//                       final List<XFile> images =
//                       await picker.pickMultiImage(imageQuality: 80);
//                       for (var image in images) {
//                         setState(() {
//                           isUploading = true;
//                         });
//                         await Api.sendChatImage(
//                             socialUserModel: widget.userModel,
//                             file: File(image.path));
//                         setState(() {
//                           isUploading = false;
//                         });
//                       }
//                     },
//                     icon: const Icon(
//                       Icons.image,
//                       color: Colors.blueAccent,
//                       size: 25,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () async {
//                       final ImagePicker picker = ImagePicker();
//                       final XFile? image = await picker.pickImage(
//                           source: ImageSource.camera, imageQuality: 80);
//                       if (image != null) {
//                         setState(() {
//                           isUploading = true;
//                         });
//                         await Api.sendChatImage(
//                             socialUserModel: widget.userModel,
//                             file: File(image.path));
//                         setState(() {
//                           isUploading = false;
//                         });
//                       }
//                     },
//                     icon: const Icon(Icons.camera_alt_outlined,
//                         color: Colors.blueAccent, size: 25),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * .02,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           MaterialButton(
//             shape: const CircleBorder(),
//             minWidth: 0,
//             padding:
//             const EdgeInsets.only(top: 10, right: 5, left: 10, bottom: 10),
//             color: Colors.green,
//             onPressed: () {
//               if (widget.messageController.text.isNotEmpty) {
//                 Api.sendMessage(
//                     userModel: widget.userModel,
//                     msg: widget.messageController.text,
//                     type: Type.text);
//                 widget.messageController.clear();
//               } else {
//                 return;
//               }
//             },
//             child: const Icon(
//               Icons.send,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }