import 'package:chatapp/modules/feeds/feeds_cubit/feeds_cubit.dart';
import 'package:chatapp/modules/feeds/widgets/post_widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  void initState() {
    // SocialCubit.get(context).getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedsCubit, FeedsState>(
      builder: (context, state) {
        var cubit = FeedsCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty,
          builder: (context) =>
              RefreshIndicator(
                onRefresh: () async{
                   cubit.getPosts();
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: const EdgeInsets.all(8.0),
                        elevation: 6.0,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Image(
                                image: const NetworkImage(
                                    'https://img.freepik.com/free-photo/top-view-people-hugging-illuminating-floor_23-2148791675.jpg?w=1060&t=st=1671660352~exp=1671660952~hmac=b3496701d08a5480b111f4dc50fd5540223d036c4ddbd985a3a4d7eb63818892'),
                                fit: BoxFit.cover,
                                height: 200.0,
                                width: double.infinity,
                                errorBuilder: (BuildContext context,
                                    Object exception,
                                    StackTrace? stackTrace) {
                                  return Container(
                                    height: 200,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(18),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.error),),
                                  );
                                },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'communicate with friends',
                                style:
                                Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return BuildPostWidget(
                            postModel: cubit.posts[index],
                          );
                        },
                        separatorBuilder: (context, index) =>
                        const SizedBox(
                          height: 8.0,
                        ),
                        itemCount: cubit.posts.length,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
          fallback: (context) {
            if (cubit.posts.isEmpty) {
              return const Center(
                child: Text('there is no posts yet'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // return const Center(
            //   child: CircularProgressIndicator(),
            // );
          },
        );
      },
    );
  }
}
