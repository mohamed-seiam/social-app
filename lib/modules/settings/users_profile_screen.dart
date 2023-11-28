
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/modules/settings/users_cubit/users_profile_cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviewUserProfile extends StatelessWidget {
  const PreviewUserProfile({Key? key, required this.userModel,}) : super(key: key);
  final SocialUserModel userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<UsersProfileCubit, UsersProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          var currentUser = UsersProfileCubit.get(context).user.currentUser!.uid;
          var profileCubit = UsersProfileCubit.get(context).specificUser;
          return ConditionalBuilder(
            condition: profileCubit!= null,
            builder:(context)=> Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Container(
                            width: double.infinity,
                            height: 140.0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(profileCubit!.cover),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 54,
                          backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(profileCubit.image),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    profileCubit.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    profileCubit.bio,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '100',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  '300',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'Photo',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  profileCubit.totalFollowing.toString(),
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'Following',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  profileCubit.totalFollowers.toString(),
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'Followers',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(profileCubit.uId != currentUser)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                           await UsersProfileCubit.get(context).followUser(userId: userModel.uId).then((value) {
                             UsersProfileCubit.get(context).getOtherUserData(otherUserId: userModel.uId);
                           });
                            },
                            child:Text(
                              profileCubit.followers!.contains(currentUser)?'UnFollow':'Follow',
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            fallback:(context)=> const Center(child: CircularProgressIndicator(),),
          );
        },
      ),
    );
  }
}