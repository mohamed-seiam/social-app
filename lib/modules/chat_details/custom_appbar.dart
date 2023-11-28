import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/modules/settings/users_cubit/users_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../network/remote/apis.dart';
import '../../network/remote/helper.dart';
import '../../shared/component/component.dart';
import '../settings/users_profile_screen.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key, required this.userModel}) : super(key: key);
  final SocialUserModel userModel;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigteTo(
            context,
           BlocProvider(
             create: (context)=> UsersProfileCubit()..getOtherUserData(otherUserId: widget.userModel.uId),
               child:PreviewUserProfile(
                 userModel: widget.userModel,
               )));
      },
      child: StreamBuilder(
          stream: Api.getUserInfo(userModel: widget.userModel),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => SocialUserModel.fromJson(e.data())).toList() ??
                    [];
            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black54,
                  ),
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.userModel.image,
                    //  maxWidth:20,
                    // maxHeight:20,
                    // scale: 100,
                    // errorListener: (object) =>
                    // const CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name : widget.userModel.name,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline!
                          ? 'Offline'
                          : MyDateUtil.getLastActiveTime(
                          context: context,
                          lastActive: list[0].lastActive!)
                          : MyDateUtil.getLastActiveTime(
                          context: context,
                          lastActive: widget.userModel.lastActive!),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}