// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/states.dart';
import '../../shared/component/component.dart';

class PostScreen extends StatelessWidget {
  var textController = TextEditingController();
  PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        return  Scaffold(
          appBar: defaultAppbar(
            context: context,
            title: 'Create Posts',
            actions:
            [
              defaultTextButton(
                function:()
                {
                  var now = DateTime.now();
                  if(SocialCubit.get(context).postImage==null)
                  {
                    SocialCubit.get(context).upLoadPost(
                        text: textController.text,
                        dateTime: now.toString(),
                    );
                  }else
                  {
                    SocialCubit.get(context).upLoadPostImage(
                        text: textController.text,
                        dateTime: now.toString(),
                    );
                  }
                },
                text:'POST',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is SocialLoadingCreatePost)
                  LinearProgressIndicator(),
                if(state is SocialLoadingCreatePost)
                  SizedBox(height: 10.0,),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(SocialCubit.get(context).model!.image!),
                    ),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:CrossAxisAlignment.start ,
                        children: [
                          Text(
                            'Mohamed Seiam',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.4
                            ),
                          ),
                          Text(
                            'public',
                            style: Theme.of(context).textTheme.caption!.copyWith(
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
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: 'what is on your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                if(SocialCubit.get(context).postImage!=null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 140.0,
                        decoration: BoxDecoration
                          (
                          borderRadius:BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: FileImage(SocialCubit.get(context).postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:(){
                          SocialCubit.get(context).deletePostImage();
                        },
                        icon:CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.close,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20.0,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed:()
                          {
                            SocialCubit.get(context).getPostImage();
                          },
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.photo,
                              ),
                              SizedBox(width: 8.0,),
                              Text(
                                  'add photo',
                              ),
                            ],
                          ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed:(){},
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '# tags',
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
