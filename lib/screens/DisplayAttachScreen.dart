//import 'dart:io';

import 'package:flutter/material.dart';
import 'util/common_functions.dart';
import 'package:video_player/video_player.dart';

class DisplayAttachScreen extends StatefulWidget {
  static const String routeName = 'DisplayAttachScreen';

  DisplayAttachScreen({Key key}) : super(key: key);

  @override
  DisplayAttachScreenState createState() => DisplayAttachScreenState();
}

class DisplayAttachScreenState extends State<DisplayAttachScreen> {
  DisplayAttachScreenState({Key key});

  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    FileInfo routeArgs = ModalRoute.of(context).settings.arguments;
    var data = routeArgs.data;

    int tim = data.tim;
    String timString = tim.toString();
    String link =
        'https://i.4cdn.org/' + routeArgs.board + '/' + timString + data.ext;

    if (data.ext == '.webm')
      return VideoWidget(link);
    else {
      return Scaffold(
          key: _scaffoldStateKey,
          appBar: AppBar(
            title: Text('your picture'),
          ),
          body: GestureDetector(
            child: Container(
              child: Center(child: getFullImage(link)),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ));
    }
  }
}

class VideoWidget extends StatefulWidget {
  final link;
  VideoWidget(this.link);
  @override
  _VideoWidgetState createState() => _VideoWidgetState(this.link);
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;
  final link;
  _VideoWidgetState(this.link);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(this.link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class FileInfo {
  dynamic data;
  String board;

  FileInfo({String board, dynamic data}) {
    this.data = data;
    this.board = board;
  }
}
