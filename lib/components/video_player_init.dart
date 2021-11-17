import 'package:flutter/material.dart';
import 'package:hilton_masale/components/video_player_screen.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerInit extends StatefulWidget {
  final String url;
  const VideoPlayerInit({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerInitState createState() => _VideoPlayerInitState();
}

class _VideoPlayerInitState extends State<VideoPlayerInit> {

  late VideoPlayerController _controller ;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.pause();
    _controller.setLooping(false);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ChewieDemo(url: widget.url)));
    },child: Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: double.infinity,child: VideoPlayer(_controller)),
        Icon(Icons.play_circle_fill,color: Colors.red,size: 60)
      ],
    ));
  }
}
