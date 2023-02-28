// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapp/cubit/cubit.dart';
import 'package:chatapp/cubit/states.dart';
import 'package:chatapp/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post_model.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.length!=null &&SocialCubit.get(context).model!=null,
          builder: (context)=> SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.all(8.0),
                  elevation: 6.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image(
                        image: NetworkImage('https://img.freepik.com/free-photo/top-view-people-hugging-illuminating-floor_23-2148791675.jpg?w=1060&t=st=1671660352~exp=1671660952~hmac=b3496701d08a5480b111f4dc50fd5540223d036c4ddbd985a3a4d7eb63818892'),
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'communicate with friends',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index)=>buildPost(SocialCubit.get(context).posts[index],context,index),
                  separatorBuilder: (context,index)=>SizedBox(height: 8.0,),
                  itemCount: SocialCubit.get(context).posts.length,
                ),
                SizedBox(height: 8.0,),
              ],
            ),
          ),
          fallback:(context)=> Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPost(SocialPostModel postmodel,context,index) => Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start ,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage('${postmodel.image}'),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start ,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${postmodel.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.4
                            ),
                          ),
                          SizedBox(width: 6.0,),
                          Icon(
                            Icons.verified_sharp,
                            color: Colors.blue,
                            size: 16.0,
                          ),
                        ],
                      ),
                      Text(
                        '${postmodel.dateTime}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0,),
                IconButton(
                  onPressed: (){},
                  icon:Icon(
                    Icons.more_horiz,
                    size: 16.0,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Text(
              '${postmodel.text}',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontSize: 14.0,
                height: 1.3,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     bottom: 10.0,
            //     top: 5.0,
            //   ),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: Wrap(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(right: 6.0),
            //           child: SizedBox(
            //             height: 25.0,
            //             child: MaterialButton(
            //               minWidth: 1.0,
            //               padding: EdgeInsets.all(0.0),
            //               onPressed: (){},
            //               child: Text(
            //                 '#softagi',
            //                 style: Theme.of(context).textTheme.caption!.copyWith(
            //                   color: defaultColor,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            if(postmodel.postImage!='')
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                width: double.infinity,
                height: 160.0,
                decoration: BoxDecoration
                  (
                  borderRadius:BorderRadius.circular(4.0),
                  image: DecorationImage(
                    image:  NetworkImage('${postmodel.postImage}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              size: 20.0,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${SocialCubit.get(context).likes[index]++}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: (){},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 20.0,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '120 comments',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: (){},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundImage: NetworkImage('${SocialCubit.get(context).model!.image}'),
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          'write a comment',
                          style: Theme.of(context).textTheme.caption!.copyWith(),
                        ),
                      ],
                    ),
                    onTap: (){},
                  ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border_outlined,
                        size: 20.0,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'LIKE',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  onTap: ()
                  {
                    SocialCubit.get(context).sendLikes(SocialCubit.get(context).postId[index]);
                  },
                ),
              ],
            ),
          ],
        ),
      )
  );
}
