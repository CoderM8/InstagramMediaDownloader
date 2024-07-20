import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instavideo_downloader/Constant/constant.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String link;
  final String img;

  const VideoPlayerScreen({Key? key, required this.link, required this.img}) : super(key: key);

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool showOverLay = false;
  bool muted = false;
  int _currentPosition = 0;
  int _duration = 0;
  bool isBuffering = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      setState(() {
        _controller!.pause();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = VideoPlayerController.file(File(widget.link));
    _attachListenerToController();
    _controller!.setLooping(true);
    _controller!.initialize().then((_) => setState(() {}));
    _controller!.play();
  }

  _attachListenerToController() {
    _controller!.addListener(
      () {
        isBuffering = _controller!.value.isBuffering;
        if (mounted) {
          setState(() {
            _currentPosition = _controller!.value.duration.inMilliseconds == 0 ? 0 : _controller!.value.position.inMilliseconds;
            _duration = _controller!.value.duration.inMilliseconds;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviePoster = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AspectRatio(aspectRatio: _controller != null ? _controller!.value.aspectRatio : 16 / 9, child: VideoPlayer(_controller!)),
        GestureDetector(
          onTap: () {
            setState(() {
              showOverLay = !showOverLay;
            });
          },
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: showOverLay
              ? Stack(alignment: Alignment.bottomLeft, children: [
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Visibility(
                          visible: !isBuffering,
                          child: IconButton(
                            icon: Icon(
                              muted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_controller!.value.volume == 0) {
                                  _controller!.setVolume(1.0);
                                } else {
                                  _controller!.setVolume(0.0);
                                }
                                muted = !muted;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextModel(
                              text: durationFormatter(_currentPosition),
                              fontSize: 16.sp,
                              fontFamily: 'M',
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                                child: VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                              colors: VideoProgressColors(playedColor: purpleColor, backgroundColor: Colors.white),
                            )),
                            SizedBox(width: 10.w),
                            TextModel(
                              text: durationFormatter(_duration),
                              fontSize: 16.sp,
                              fontFamily: 'M',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: RawMaterialButton(
                      padding: EdgeInsets.all(10.r),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      fillColor: Colors.black.withOpacity(0.5),
                      shape: const CircleBorder(),
                      child: SvgPicture.asset(
                        _controller!.value.isPlaying ? 'assets/icons/pause.svg' : 'assets/icons/play.svg',
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
                          showOverLay = _controller!.value.isPlaying ? false : true;
                        });
                      },
                    ),
                  ),
                ])
              : const SizedBox.shrink(),
        ),
      ],
    );
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              opacity: .3,
              image: FileImage(File(widget.img)),
            )),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(child: moviePoster),
            Visibility(
              visible: isBuffering,
              child: Container(
                color: Colors.grey.shade800,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String durationFormatter(int milliSeconds) {
  int seconds = milliSeconds ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  final minutes = seconds ~/ 60;
  seconds = seconds % 60;
  final hoursString = hours >= 10
      ? '$hours'
      : hours == 0
          ? '00'
          : '0$hours';
  final minutesString = minutes >= 10
      ? '$minutes'
      : minutes == 0
          ? '00'
          : '0$minutes';
  final secondsString = seconds >= 10
      ? '$seconds'
      : seconds == 0
          ? '00'
          : '0$seconds';
  final formattedTime = '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';
  return formattedTime;
}
