// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/cubit/states.dart';
import 'package:chatapp/modules/feeds/feeds_cubit/feeds_cubit.dart';
import 'package:chatapp/modules/login/social_login_screen.dart';
import 'package:chatapp/network/local/cach_helper.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../modules/posts/posts.dart';

class SocialHomeScreen extends StatelessWidget {
  const SocialHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialAddPost) {
          navigteTo(context, BlocProvider(
            create: (context)=>FeedsCubit(),
              child: PostScreen()));
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            titleSpacing: 20.0,
            actions: [
              IconButton(
                onPressed: () async {
                  CachHelper.deleteData(key: 'uId');
                  await FirebaseAuth.instance.signOut();
                  navigateAndFinish(context, SocialLoginScreen());
                  Phoenix.rebirth(context);
                },
                icon: Icon(Icons.logout_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.youtube_searched_for_sharp),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_sharp),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wechat_sharp),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.upload_file),
                label: 'Post',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.location_on_outlined),
              //   label: 'Users',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_accessibility_outlined),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
