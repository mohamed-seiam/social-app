// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/cubit/states.dart';
import 'package:chatapp/modules/edit_profile/edit_profile.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit= SocialCubit.get(context).model;

        return Padding(
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
                        decoration: BoxDecoration
                          (
                          borderRadius:BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                          image: DecorationImage(
                            image:  NetworkImage('${cubit!.cover}'),
                            fit: BoxFit.cover,
                          ),
                        ),

                      ),
                    ),
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage('${cubit!.image}'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.0,),
              Text(
                '${cubit.name}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 4.0,),
              Text(
                '${cubit.bio}',
                style: Theme.of(context).textTheme.caption,
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
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              'Posts',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              '300',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              'Photo',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              '100',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              'Following',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              '120',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              'Followers',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),

                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:(){},
                      child: Text(
                        'Add Photo',
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  OutlinedButton(
                      onPressed:()
                      {
                        navigteTo(context,
                            EditProfileScreen(),
                        );
                      },
                      child:Icon
                        (
                        Icons.edit,
                      ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
