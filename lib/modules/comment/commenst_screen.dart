import 'dart:io';
import 'package:chatapp/modules/comment/widgets/comment_input_widget.dart';
import 'package:chatapp/modules/comment/widgets/comment_item.dart';
import 'package:chatapp/modules/comment/widgets/shimmer_loading_comment.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/comment_cubit.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.postId}) : super(key: key);
  final String postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
TextEditingController commentController = TextEditingController();
ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    commentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    CommentCubit.get(context).getComments(postId: widget.postId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var cubit = CommentCubit.get(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: () {
            if (cubit.showEmoji) {
              setState(() {
                cubit.showEmoji = !cubit.showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                BlocBuilder<CommentCubit, CommentState>(
                  builder: (context, state) {
                    var cubit = CommentCubit.get(context);
                    return Expanded(
                      child: Column(
                        children: [
                          ConditionalBuilder(
                            condition: cubit.comments.isNotEmpty,
                            builder: (context) => Flexible(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: cubit.comments.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return CommentItem(
                                    commentModel: cubit.comments[index],
                                  );
                                },
                              ),
                            ),
                            fallback: (context) {
                              if (cubit.comments.isEmpty) {
                                return const SizedBox.shrink();
                              }else if(cubit.comments.isEmpty && (state is CommentRemoveCommentImage || state is CommentCreateCommentLoading) ){
                                return const ShimmerComment();
                              }
                              else{
                                return const Center(child: CircularProgressIndicator(),);
                              }
                            },
                          ),
                          if(state is CommentCreateCommentLoading || state is CommentRemoveCommentImage)
                            const ShimmerComment(),
                        ],
                      ),
                    );
                  },
                ),
                CommentInput(postIdl: widget.postId,commentController: commentController,),
                if (cubit.showEmoji)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: EmojiPicker(
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                        // Set it to null to hide the Backspace-Button
                      },
                      textEditingController: commentController,
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
}


