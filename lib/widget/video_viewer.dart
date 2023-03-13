import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  const VideoViewer({super.key, required this.videoUrl});
  final String videoUrl;
  static const String routePath = '/videoViewer';

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late final PodPlayerController controller;
  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(
        widget.videoUrl,
      ),
    )..initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PodVideoPlayer(controller: controller),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
