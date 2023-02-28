// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/modules/chat_details/chat_details.dart';
import 'package:chatapp/shared/component/component.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/states.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        return ConditionalBuilder(
          condition:SocialCubit.get(context).allUsers.isNotEmpty ,
          builder:(context)=>ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder:(context,index)=>buildChatItem(SocialCubit.get(context).allUsers[index],context),
            separatorBuilder:(context,index)=>mydivider(),
            itemCount:SocialCubit.get(context).allUsers.length,
          ),
          fallback:(context)=> Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel socialUserModel,context) =>  InkWell(
    onTap: ()
    {
      navigteTo(context , ChatDetailsScreen(userModel: socialUserModel),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage('${socialUserModel.image}'),
          ),
          SizedBox(width: 15.0,),
          Text(
            '${socialUserModel.name}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 1.4
            ),
          ),
        ],
      ),
    ),
  );
}
