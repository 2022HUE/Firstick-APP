import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'handpainter.dart';

double degree = 270;
double radian = degree * math.pi / 180;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`

  // availableCameras가 안될 것을 대비
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  // 사용 가능한 카메라 불러오기
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  // 현재 전면(first) 카메라 불러옴
  final firstCamera = cameras.first;

  runApp(
    Camera(
      // Pass the appropriate camera to the Camera widget.
      camera: firstCamera,
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class Camera extends StatefulWidget {
  const Camera({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  void _setupCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    setState(() {
      // Get a specific camera from the list of available cameras.
      final firstCamera = cameras.first;
    });
  }

  @override
  void initState() {
    super.initState();
    _setupCamera();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
        body: FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Stack(children: <Widget>[
            Center(
              child: Transform.scale(
                scale: _controller.value.aspectRatio / deviceRatio,
                child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Center(
                        child: Transform.rotate(
                      angle: radian,
                      child: CameraPreview(_controller),
                    ))),
              ),
            ),
            // 카메라 위 painter widget 불러오기
            Center(child: drawHands)
          ]);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
  // 손 그리는 painter 관련 에러 발생하여 주석 처리함
  // Widget get drawHands => ModelPainter(
  //       customPainter: HandsPainter(),
  //     );
}

class ModelPainter extends StatelessWidget {
  ModelPainter({
    required this.customPainter,
    Key? key,
  }) : super(key: key);

  final CustomPainter customPainter;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: customPainter,
    );
  }
}
