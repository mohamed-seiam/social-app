import 'package:chatapp/modules/feeds/widgets/MakeLikeAndComment.dart';
import 'package:chatapp/modules/feeds/widgets/number_of_likes_and_comments.dart';
import 'package:chatapp/modules/feeds/widgets/post_body.dart';
import 'package:flutter/material.dart';
import '../../../models/post_model.dart';
import 'header_post.dart';

class BuildPostWidget extends StatelessWidget {
  const BuildPostWidget({
    Key? key,
    required this.postModel,
  }) : super(key: key);
  final SocialPostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderPost(postModel: postModel),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
            ),
            PostBody( postModel: postModel),
            LikesAndCommentsNumber(postModel: postModel),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
           MakeLikeAndComment(postModel: postModel),
          ],
        ),
      ),
    );
  }
}
