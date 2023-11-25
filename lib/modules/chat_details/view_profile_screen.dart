import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/network/remote/helper.dart';
import 'package:flutter/material.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({Key? key, required this.userModel})
      : super(key: key);
  final SocialUserModel userModel;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Joined On:',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          Text(
            MyDateUtil.getLastMessageTime(
              context: context,
              time: userModel.createdAt,
              showYear: true,
            ),
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(userModel.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * .05,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: mq.width,
                height: mq.height * .03,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .1),
                child: CachedNetworkImage(
                  imageUrl: userModel.image,
                  width: mq.height * .2,
                  height: mq.height * .2,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(
                height: mq.height * .03,
              ),
              Text(
                userModel.email,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
              ),
              SizedBox(
                height: mq.height * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bio: ',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    userModel.bio,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
