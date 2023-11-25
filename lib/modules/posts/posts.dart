// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/modules/feeds/feeds_cubit/feeds_cubit.dart';
import 'package:chatapp/modules/posts/widgets/preview_video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/component.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    return BlocConsumer<FeedsCubit, FeedsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppbar(
            context: context,
            title: 'Create Posts',
            actions: [
              defaultTextButton(
                function: () async {
                  var now = Timestamp.now();
                  if (FeedsCubit.get(context).postImage != null) {
                    FeedsCubit.get(context).upLoadPostImage(
                      text: textController.text,
                      dateTime: now,
                    );
                  } else if (FeedsCubit.get(context).postVideo != null) {
                    FeedsCubit.get(context).upLoadPostVideo(
                      text: textController.text,
                      dateTime: now,
                    );
                  } else {
                    FeedsCubit.get(context)
                        .upLoadPost(text: textController.text, dateTime: now);
                  }
                },
                text: 'POST',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is FeedsLoading) LinearProgressIndicator(),
                if (state is FeedsLoading)
                  SizedBox(
                    height: 10.0,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(SocialCubit.model?.image ??
                          'https://img.freepik.com/free-photo/stylish-man-posing-building-scene_158595-2391.jpg?w=900&t=st=1672078161~exp=1672078761~hmac=11ea5f7cca47eff6270a76ac033b9d928bb7138909f2d37da234ce7b23e54f39'),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SocialCubit.model!.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, height: 1.4),
                          ),
                          Text(
                            'public',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      height: 1.4,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 8,
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'what is on your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
               if(FeedsCubit.get(context).postImage != null)
                     Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 250.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              image: DecorationImage(
                                image: FileImage(
                                    FeedsCubit.get(context).postImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              FeedsCubit.get(context).deletePostImage();
                            },
                            icon: CircleAvatar(
                              radius: 20,
                              child: Icon(
                                Icons.close,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                if(FeedsCubit.get(context).postVideo!=null)
                  Expanded(child: PreviewVideo()),
                SizedBox(
                  height: 3.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          FeedsCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'add photo',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          FeedsCubit.get(context).getPostVideo();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_camera_back_outlined,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'Add Video',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
