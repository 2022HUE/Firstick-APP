import 'dart:ui';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chopstick2/utils/isolate_utils.dart';
import 'package:chopstick2/services/locator.dart';
import 'package:chopstick2/services/inference_service.dart';
import 'preview.dart';

double degree = 270;
double radian = degree * math.pi / 180;

class Camera extends StatefulWidget {
  const Camera({
    Key? key,
  }) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  late CameraDescription _cameraDescription;

  late final double deviceRatio;
  late bool _streaming;
  bool _draw = false;
  bool _predicting = false;

  late InferenceService _inferenceService; // inference
  late IsolateUtils _isolateUtils; // isolate_utils

  @override
  void initState() {
    _inferenceService = locator<InferenceService>();

    _initStateAsync();
    super.initState();
  }

  void _initStateAsync() async {
    _isolateUtils = IsolateUtils();
    await _isolateUtils.setIsolate(); // setupIsolate

    await main(); // setupCamera
    _predicting = false;
  }

  // camera init
  Future<void> main() async {
    // availableCameras가 안될 것을 대비
    WidgetsFlutterBinding.ensureInitialized();

    // 사용 가능한 카메라 불러오기
    _cameras = await availableCameras();
    // 현재 전면(first) 카메라 불러옴
    _cameraDescription = _cameras.first;

    _streaming = false; // 카메라 켜자마자 손 감지를 위해 true로 지정
    _newCamera(_cameraDescription); // camera 실행
  }

  void _newCamera(CameraDescription cameraDescription) async {
    // controller setting
    // To display the current output from the Camera, create a CameraController.
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _controller!.addListener(() {
      if (mounted) setState(() {});

      if (_controller!.value.hasError) {
        _showSnackBar('카메라에 문제가 발생했습니다.');
      }
    });

    try {
      await _controller!.initialize().then((value) {
        if (!mounted) return;
        // _imageStreamToggle;
      });
    } on CameraException catch (e) {
      _showSnackBar('카메라에 문제가 발생했습니다.');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    _controller = null;
    _isolateUtils.dispose();
    _inferenceService.inferenceResults = null;
    super.dispose();
  }

  // 스낵바 띄우기
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _imageStreamToggle;
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        appBar: _buildAppBar,
        body: Preview(
          controller: _controller,
          draw: _draw,
        ),
        floatingActionButton: _button,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  AppBar get _buildAppBar => AppBar();

  Row get _button => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => _cameraDirectionToggle,
            color: Colors.white,
            icon: const Icon(
              Icons.cameraswitch,
            ),
          ),
          IconButton(
            onPressed: () => _imageStreamToggle,
            color: Colors.white,
            icon: const Icon(
              Icons.filter_center_focus,
            ),
          ),
        ],
      );

  // 실시간 이미지 데이터 전송하기
  void get _imageStreamToggle {
    setState(() {
      _draw = !_draw;
    });

    _streaming = !_streaming;
    if (_streaming) {
      _controller!.startImageStream(
        (CameraImage cameraImage) async =>
            await _inference(cameraImage: cameraImage),
      );
    } else {
      _controller!.stopImageStream();
    }
  }

  // 카메라 전면 <-> 후면
  void get _cameraDirectionToggle {
    setState(() {
      _draw = false;
    });
    _streaming = false;
    if (_controller!.description.lensDirection ==
        _cameras.first.lensDirection) {
      _newCamera(_cameras.last);
    } else {
      _newCamera(_cameras.first);
    }
  }

  Future<void> _inference({required CameraImage cameraImage}) async {
    if (!mounted) return;

    // 모델의 인터프리터가 제대로 작동중일때
    if (_inferenceService.model.interpreter != null) {
      if (_predicting || !_draw) {
        return;
      }
      setState(() {
        _predicting = true;
      });

      if (_draw) {
        debugPrint('***********draw***********'); // debug!
        await _inferenceService.inference(
          cameraImage: cameraImage,
          isolateUtils: _isolateUtils,
        );
      }

      setState(() {
        _predicting = false;
      });
    }
  }
}
