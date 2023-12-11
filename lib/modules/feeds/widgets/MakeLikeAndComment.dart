import 'package:chatapp/models/post_model.dart';
import 'package:chatapp/modules/feeds/widgets/size_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/cubit.dart';
import '../../comment/commenst_screen.dart';
import '../../comment/cubit/comment_cubit.dart';
import '../feeds_cubit/feeds_cubit.dart';

class MakeLikeAndComment extends StatelessWidget {
  const MakeLikeAndComment({Key? key, required this.postModel}) : super(key: key);
final SocialPostModel postModel;
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
          child: InkWell(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.0,
                  backgroundImage:
                  NetworkImage(SocialCubit.model?.image ?? ''),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  'write a comment',
                  style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                SizeTransition1(
                  BlocProvider(
                    create: (context) => CommentCubit(),
                    child: CommentScreen(
                      postId:postModel.postId!,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        InkWell(
          child: Row(
            children: [
              Icon(
                postModel.likes!.contains(
                    FirebaseAuth.instance.currentUser?.uid)
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                size: 20.0,
                color: Colors.red,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                postModel.likes!.contains(
                    FirebaseAuth.instance.currentUser?.uid)
                    ? 'DisLike'
                    : 'Like',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          onTap: () {
            FeedsCubit.get(context)
                .likePost(postId: postModel.postId);
          },
        ),
      ],
    );
  }
}
