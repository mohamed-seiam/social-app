import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../shared/component/component.dart';
import '../../chat_details/view_profile_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({Key? key, required this.userModel}) : super(key: key);
  final SocialUserModel userModel;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        height: mq.height * .37,
        width: mq.width * .6,
        child: Stack(
          children: [
            Positioned(
              top: mq.height * .075,
              left: mq.width * .07,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .01),
                child: CachedNetworkImage(
                  imageUrl: userModel.image,
                  width: mq.width * .5,
                  height: mq.width * .5,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
            ),
            Positioned(
              left: mq.width * .04,
              top: mq.height * .02,
              width: mq.width * .55,
              child: Text(
                userModel.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 6,
              child: MaterialButton(
                onPressed: () {
                  navigteTo(
                    context,
                    ViewProfileScreen(
                      userModel: userModel,
                    ),
                  );
                },
                minWidth: 0,
                padding: const EdgeInsets.all(0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
