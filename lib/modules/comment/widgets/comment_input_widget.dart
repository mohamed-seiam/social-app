import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/comment_cubit.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({Key? key, required this.postIdl, required this.commentController,}) : super(key: key);
  final String postIdl;
  final TextEditingController commentController;
  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCubit,CommentState>(
      builder: (context, state) {
        var cubit = CommentCubit.get(context);
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * .01,
              horizontal: MediaQuery.of(context).size.width * .011),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              color: Colors.black54.withOpacity(0.3),
                              width: 1)),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                cubit.showEmoji = !cubit.showEmoji;
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
                              scrollPhysics: const BouncingScrollPhysics(),
                              controller: widget.commentController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              minLines: 1,
                              onTap: () {
                                if (cubit.showEmoji) {
                                  setState(() {
                                    cubit.showEmoji = !cubit.showEmoji;
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: 'Write a Comment...',
                                hintStyle: TextStyle(
                                  color: Colors.blueAccent,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await CommentCubit.get(context).getCommentImage();
                              setState(() {
                                cubit.isUploading = true;
                              });
                            },
                            icon: const Icon(
                              Icons.image,
                              color: Colors.blueAccent,
                              size: 25,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .02,
                          ),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    shape: const CircleBorder(),
                    minWidth: 0,
                    padding: const EdgeInsets.only(
                        top: 10, right: 5, left: 10, bottom: 10),
                    color: Colors.blue,
                    onPressed: () async {
                      if (CommentCubit.get(context).commentImage != null) {
                        setState(() {
                          cubit.isUploading = true;
                        });
                        if (!mounted) {
                          return;
                        }
                        CommentCubit.get(context).upLoadCommentImage(
                          posId: widget.postIdl,
                          dateTime: DateTime.now().toString(),
                          comment: widget.commentController.text,
                        );
                        widget.commentController.clear();
                        cubit.deleteCommentImage();
                      } else {
                        CommentCubit.get(context).sendComment(
                            postId: widget.postIdl,
                            comment: widget.commentController.text,
                            dateTime: DateTime.now().toString(),
                            image: '');
                        widget.commentController.clear();
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
              if (CommentCubit.get(context).commentImage != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                      borderRadius:const BorderRadius.all(Radius.circular(12)),
                      child: Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.file(
                              CommentCubit.get(context).commentImage!,
                              width: 140,
                              height: 140,
                              fit: BoxFit.fill,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              CommentCubit.get(context).deleteCommentImage();
                            },
                            icon: const CircleAvatar(
                              radius: 20,
                              child: Icon(
                                Icons.close,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
            ],
          ),
        );
      },
    );
  }
}
