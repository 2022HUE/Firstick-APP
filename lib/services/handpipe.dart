import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../setting/models.dart';
import '../utils/image_utils.dart';

class Handpipe {
  Handpipe({this.interpreter}) {
    debugPrint('Hello Handpipe');
    loadModel();
    debugPrint(interpreter.toString());
  }

  // init
  final int inputSize = 224;
  final double existThreshold = 0.1;
  final double scoreThreshold = 0.3;

  // Shapes/Types of output tensors
  late List<List<int>> outputShapes;
  late List<TfLiteType> outputTypes;

  @override
  Interpreter? interpreter;

  @override
  List<Object> get props => [];

  @override
  int get getAddress => interpreter!.address;

  /// Loads interpreter from asset
  Future<void> loadModel() async {
    debugPrint('loadModel_Handpipe');

    try {
      final interpreterOptions = InterpreterOptions();

      interpreter ??= await Interpreter.fromAsset(Models.handpipe,
          options: interpreterOptions);

      final outputTensors = interpreter!.getOutputTensors();
      outputShapes = [];
      outputTypes = [];

      outputTensors.forEach((tensor) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage) {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  Map<String, dynamic>? predict(imageLib.Image image) {
    // Interpreter? interpreter;
    debugPrint(interpreter.toString());
    if (interpreter == null) {
      debugPrint('[!] Handpipe - Interpreter is null');
      return null;
    }

    if (Platform.isAndroid) {
      // 카메라 방향 270도로 바꾸기
      image = imageLib.copyRotate(image, -90);
      // 좌우반전 시키기
      image = imageLib.flipHorizontal(image);
      image = imageLib.flipVertical(image);
    }
    final tensorImage = TensorImage(TfLiteType.float32);
    tensorImage.loadImage(image);
    final inputImage = getProcessedImage(tensorImage);

    TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputExist = TensorBufferFloat(outputShapes[1]);
    TensorBuffer outputScores = TensorBufferFloat(outputShapes[2]);

    final inputs = <Object>[inputImage.buffer];

    final outputs = <int, Object>{
      0: outputLandmarks.buffer,
      1: outputExist.buffer,
      2: outputScores.buffer,
    };

    // Null-Safety error 예외처리(try-catch)
    try {
      interpreter!.runForMultipleInputs(inputs, outputs);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (outputExist.getDoubleValue(0) < existThreshold ||
        outputScores.getDoubleValue(0) < scoreThreshold) {
      return null;
    }

    final landmarkPoints = outputLandmarks.getDoubleList().reshape([21, 3]);
    final landmarkResults = <Offset>[];
    for (var point in landmarkPoints) {
      landmarkResults.add(Offset(
        point[0] / inputSize * image.width,
        point[1] / inputSize * image.height,
      ));
    }

    // debugPrint(outputLandmarks.getDoubleList().toString());
    // debugPrint(outputLandmarks.getDoubleList().length.toString());
    return {'point': landmarkResults};
  }
}

// 손 인식하는 handler 생성
Map<String, dynamic>? handDetector(Map<String, dynamic> params) {
  // cameraImage
  final image = ImageUtils.convertCameraImage(params['cameraImage']);
  // handpipe model interpreter address
  final handpipe =
      Handpipe(interpreter: Interpreter.fromAddress(params['modelAddress']));
  final res = handpipe.predict(image!);

  return res;
}
