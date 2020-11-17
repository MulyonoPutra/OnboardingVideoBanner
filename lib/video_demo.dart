import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

import 'package:video_player_demo/main.dart';

class ChewieDemo extends StatefulWidget {
  ChewieDemo({this.title = 'Chewie Demo'});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  Timer _timer;
  int _videoDuration = 84;

  @override
  void initState() {
    super.initState();
    this.initializePlayer();
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_videoDuration < 1) {
            timer.cancel();
          } else {
            _videoDuration = _videoDuration - 1;
          }
        },
      ),
    );
  }

  /*  
  Discards any resources used by the object. After this is called, 
  the object is not in a usable state and should be discarded.
  */ 
 @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-forest-stream-in-the-sunlight-529-large.mp4');
    await _videoPlayerController1.initialize();
    _videoPlayerController2 =
        VideoPlayerController.asset('assets/appvideo.mp4');
    await _videoPlayerController2.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
      autoPlay: true,
      showControls: false,
      autoInitialize: true,
      allowFullScreen: true,
      allowedScreenSleep: false,
    );

    setState(() {
      _chewieController.enterFullScreen();
      print(_videoPlayerController1.value.duration);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: [
                Expanded(
                  child: Center(
                    child: _chewieController != null &&
                            _chewieController
                                .videoPlayerController.value.initialized
                        ? Chewie(
                            controller: _chewieController,
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: 0.25,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                  ),
                ),
                (_videoDuration != 0)
                    ? Container(
                        height: 750,
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          onPressed: () {
                            _videoDuration = 1;
                            print('test');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          },
                          child: Text("Skip Video - $_videoDuration"),
                        ),
                      )
                    : Container(
                        height: 750,
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          onPressed: () {
                            _videoDuration = 1;
                            print('test');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          },
                          child: Text("Complete"),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
