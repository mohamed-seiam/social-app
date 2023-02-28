// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/cubit/states.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/component.dart';

class ChatDetailsScreen extends StatelessWidget {
  final SocialUserModel userModel;
  final time = DateTime.now();
  var messageController = TextEditingController();

  ChatDetailsScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        '${userModel.image}',
                      ),
                    ),
                    SizedBox(width: 15.0,),
                    Text(
                      '${userModel.name}',
                    ),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) =>
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                var message = SocialCubit
                                    .get(context)
                                    .messages[index];
                                if (SocialCubit
                                    .get(context)
                                    .model!
                                    .uId == message.senderId) {
                                  return buildMyMessage(message);
                                }
                                return buildMessage(message);
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 15.0,),
                              itemCount: SocialCubit
                                  .get(context)
                                  .messages
                                  .length,
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(15.0,),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: TextFormField(
                                      controller: messageController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '  type your message here ...',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  color: defaultColor,
                                  child: MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context).sendMessage(
                                        receiverId: userModel.uId,
                                        text: messageController.text,
                                        dateTime: DateTime.now().toString(),
                                      );
                                      messageController.text = '';
                                    },
                                    minWidth: 1.0,
                                    child: Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(SocialMessageModel messageModel) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10),
                topEnd: Radius.circular(10),
                topStart: Radius.circular(10),
              )
          ),
          child: Text(
            '${messageModel.text}',
          ),
        ),
      );

  Widget buildMyMessage(SocialMessageModel messageModel) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
              color: defaultColor.withOpacity(0.2),
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                topStart: Radius.circular(10),
              )
          ),
          child: Text(
            '${messageModel.text}',
          ),
        ),
      );
}
