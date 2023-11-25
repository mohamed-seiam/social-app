import 'package:chatapp/models/post_model.dart';
import 'package:chatapp/modules/feeds/widgets/size_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../comment/commenst_screen.dart';
import '../../comment/cubit/comment_cubit.dart';

class LikesAndCommentsNumber extends StatelessWidget {
  const LikesAndCommentsNumber({Key? key, required this.postModel}) : super(key: key);
final SocialPostModel postModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_border_outlined,
                      size: 20.0,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      postModel.totalLikes.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ),
          Expanded(
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 20.0,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '${postModel.totalComments.toString()} comment',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  SizeTransition1(
                    BlocProvider(
                      create: (context) => CommentCubit(),
                      child: CommentScreen(
                        postId: postModel.postId!,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
