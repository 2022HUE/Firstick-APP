import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:chopstick2/services/locator.dart';
import '../utils/isolate_utils.dart';
import 'handpipe.dart';

class InferenceService {
  late Handpipe model; // handpipe model 불러오기
  late Function detetor;
  Map<String, dynamic>? inferenceResults;

  Future<Map<String, dynamic>?> inference({
    // 카메라 이미지 + isolate
    required CameraImage cameraImage,
    required IsolateUtils isolateUtils,
  }) async {
    final responsePort = ReceivePort();

    isolateUtils.sendMessage(
      handler: detetor,
      params: {
        'cameraImage': cameraImage,
        'modelAddress': model.getAddress,
      },
      sendPort: isolateUtils.sendPort,
      responsePort: responsePort,
    );

    inferenceResults = await responsePort.first;
    responsePort.close();
  }

  void setModelConfig() {
    model = locator<Handpipe>();
    detetor = handDetector;
  }
}
