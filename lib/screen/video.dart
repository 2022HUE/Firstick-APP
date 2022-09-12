import 'dart:async';
import 'package:camera/camera.dart';
import 'package:chopstick2/screen/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chopstick2/services/locator.dart';
import 'package:chopstick2/services/inference_service.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late final CameraDescription firstCamera;

  @override
  void initState() {
    // VideoPlayerController를 저장하기 위한 변수를 만듭니다. VideoPlayerController는
    // asset, 파일, 인터넷 등의 영상들을 제어하기 위해 다양한 생성자를 제공합니다.
    _controller = VideoPlayerController.asset('assets/video/Tutorial.mp4');

    // 컨트롤러를 초기화하고 추후 사용하기 위해 Future를 변수에 할당합니다.
    _initializeVideoPlayerFuture = _controller.initialize();

    // 비디오를 반복 재생하기 위해 컨트롤러를 사용합니다.
    _controller.setLooping(true);

    super.initState();

    _setupCameras();
  }

  void _setupCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    // 디바이스에서 이용가능한 카메라 목록을 받아옵니다.
    final cameras = await availableCameras();
    setState(() {
      firstCamera = cameras[0];
    });
  }

  @override
  void dispose() {
    // 자원을 반환하기 위해 VideoPlayerController를 dispose 시키세요.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chopsticks Video'),
      ),
      // VideoPlayerController가 초기화를 진행하는 동안 로딩 스피너를 보여주기 위해
      // FutureBuilder를 사용합니다.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // 만약 VideoPlayerController 초기화가 끝나면, 제공된 데이터를 사용하여
            // VideoPlayer의 종횡비를 제한하세요.
            return Container(
              alignment: Alignment.center,
              width: double.infinity,
              // height: 200, //height 설정가능
              child: AspectRatio(
                //여기는 영상부분---------------------------
                aspectRatio: _controller.value.aspectRatio, //영상 비율
                // 영상을 보여주기 위해 VideoPlayer 위젯을 사용합니다.
                child: VideoPlayer(_controller), //--------------------------
              ),
            );
          } else {
            // 만약 VideoPlayerController가 여전히 초기화 중이라면,
            // 로딩 스피너를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      floatingActionButton: Stack(
        //여기가 버튼
        children: <Widget>[
          Align(
            alignment: Alignment(
                Alignment.bottomRight.x, Alignment.bottomRight.y - 0.2),
            child: FloatingActionButton(
              onPressed: () {
                // 재생/일시 중지 기능을 `setState` 호출로 감쌉니다. 이렇게 함으로써 올바른 아이콘이
                // 보여집니다.
                setState(
                  () {
                    // 영상이 재생 중이라면, 일시 중지 시킵니다.
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      // 만약 영상이 일시 중지 상태였다면, 재생합니다.
                      _controller.play();
                    }
                  },
                );
              },
              heroTag: 'contact',
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                locator<InferenceService>().setModelConfig();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Camera();
                  },
                ));
                // builder: (context) => Camera(
                //       camera: firstCamera,
                //     )));
              },
              // heroTag: 'contact',
              child: Icon(Icons.next_plan),
            ),
          ),
        ],
      ),
      // 이 마지막 콤마는 build 메서드에 자동 서식이 잘 적용될 수 있도록 도와줍니다.
    );
  }
}
