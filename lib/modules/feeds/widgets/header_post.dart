import 'package:chatapp/models/post_model.dart';
import 'package:chatapp/modules/feeds/widgets/size_transition.dart';
import 'package:chatapp/modules/feeds/widgets/update_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../cubit/cubit.dart';
import '../feeds_cubit/feeds_cubit.dart';

class HeaderPost extends StatelessWidget {
  const HeaderPost({Key? key, required this.postModel}) : super(key: key);
final SocialPostModel postModel;
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage('${postModel.image}'),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${postModel.name}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, height: 1.4),
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  const Icon(
                    Icons.verified_sharp,
                    color: Colors.blue,
                    size: 16.0,
                  ),
                ],
              ),
              Text(
                DateFormat('dd/MMM/yyy')
                    .format(postModel.dateTime!.toDate()),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        if(postModel.uId==SocialCubit.get(context).user.currentUser!.uid)
          IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(300, 302, 302, 300),
                items: [
                  PopupMenuItem(
                    value: 'update',
                    onTap: () {
                      Navigator.push(
                        context,
                        SizeTransition1(
                          BlocProvider(
                            create: (context) => FeedsCubit(),
                            child: UpdatePostWidget(
                                postModel:postModel),
                          ),
                        ),
                      );
                    },
                    child: const Text('Update'),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      await FeedsCubit.get(context).deletePost(
                          model:postModel);
                    },
                    value: 'delete',
                    child: const Text('Delete'),
                  ),
                ],
                // Handle the selected option
              );
            },
            icon: const Icon(
              Icons.more_horiz,
              size: 16.0,
            ),
          ),
      ],
    );
  }
}
