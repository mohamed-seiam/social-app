import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/post_model.dart';
import 'package:chatapp/modules/feeds/widgets/post_vidoe_widget.dart';
import 'package:flutter/material.dart';

class PostBody extends StatelessWidget {
  const PostBody({Key? key, required this.postModel}) : super(key: key);
final SocialPostModel postModel;
  @override
  Widget build(BuildContext context) {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.vertical,
        children: [
          if (postModel.text!.isNotEmpty)
            Text(
              '${postModel.text}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 14.0,
                height: 1.3,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          if(postModel.postVideo !='')
            PostVideoWidget(postModel: postModel),
          if (postModel.postImage != '')
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: CachedNetworkImage(
                imageUrl: postModel.postImage!,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image,
                  size: 70,
                ),
              ),
            ),
        ],
      );
  }
}
