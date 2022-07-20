import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  const VideoPlayerWidget({Key? key, required this.videoPlayerController, required this.looping}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late ChewieController _chewieController;

  @override
  void initState(){
    super.initState();

    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 9/19.5,
        autoInitialize: true,
      looping: widget.looping
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Chewie(
          controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
