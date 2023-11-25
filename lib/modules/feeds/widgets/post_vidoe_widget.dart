import 'package:chatapp/models/post_model.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostVideoWidget extends StatefulWidget {
  const PostVideoWidget({Key? key, required this.postModel}) : super(key: key);
  final SocialPostModel postModel;

  @override
  State<PostVideoWidget> createState() => _PostVideoWidgetState();
}

class _PostVideoWidgetState extends State<PostVideoWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.postModel.postVideo!));
    _chewieController = ChewieController(
        videoPlayerController: _controller, allowFullScreen: true);
    final playerWidget = Chewie(
      controller: _chewieController,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child:Chewie(
        controller: _chewieController,
      ),
    );
  }
}
