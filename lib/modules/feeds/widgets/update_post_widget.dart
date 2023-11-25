import 'package:chatapp/models/post_model.dart';
import 'package:chatapp/modules/feeds/feeds_cubit/feeds_cubit.dart';
import 'package:flutter/material.dart';

class UpdatePostWidget extends StatefulWidget {
  const UpdatePostWidget({Key? key, required this.postModel}) : super(key: key);
final SocialPostModel postModel;
  @override
  State<UpdatePostWidget> createState() => _UpdatePostWidgetState();
}

class _UpdatePostWidgetState extends State<UpdatePostWidget> {
  late TextEditingController updateController ;
  @override
  void initState() {
    updateController = TextEditingController();
    updateController.text = widget.postModel.text!;
    super.initState();
  }
  @override
  void dispose() {
    updateController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditPost'),
        actions: [
          IconButton(
            onPressed: () async {
              if(updateController.text.isNotEmpty){
                FeedsCubit.get(context).editPost(updateController.text,postId: widget.postModel.postId!);
              }else {
                return;
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*.03,),
              if(widget.postModel.postImage!='')
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height/2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        image: DecorationImage(
                          image:
                          NetworkImage(widget.postModel.postImage!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FeedsCubit.get(context).deletePostImage();
                        setState(() {
                          widget.postModel.postImage = '';
                        });
                      },
                      icon:const CircleAvatar(
                        radius: 20,
                        child: Icon(
                          Icons.close,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
             SizedBox(height: MediaQuery.of(context).size.height*.01,),
              const Padding(
              padding: EdgeInsets.all(14.0),
              child: Align(
                 alignment: Alignment.topLeft,
                   child:Text('Description')),
            ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextField(
                  onTap: (){},
                  maxLines: null,
                  controller: updateController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
