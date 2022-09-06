import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

// load models/labels data
import '../../setting/models.dart';
// import '../../setting/labels.dart';

class Handpipe {
  // init
  final int input_size = 224;
  final double exist_threshold = 0.1;
  final double score_threshold = 0.3;

  // Shapes of output tensors
  late List<List<int>> _outputShapes;
  late List<TfLiteType> _outputTypes;

  late Interpreter _interpreter;
  final interpreterOptions = InterpreterOptions();
  // late List<String> _labels;

  Interpreter get interpreter => _interpreter;
  // List<String> get labels => _labels;

  Handpipe() {
    loadModel(interpreter: interpreter);
  }

  /// Loads interpreter from asset
  void loadModel({required Interpreter interpreter}) async {
    try {
      if (interpreter == null) {
        _interpreter = await Interpreter.fromAsset(
          Models.handpipe,
          options: interpreterOptions,
        );
      }

      var outputTensors = _interpreter.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      outputTensors.forEach((tensor) {
        _outputShapes.add(tensor.shape);
        _outputTypes.add(tensor.type);
      });
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage) {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(input_size, input_size, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  Map<String, dynamic>? predict(imageLib.Image image) {
    if (_interpreter == null) {
      print('Interpreter not initialized');
      return null;
    }

    if (Platform.isAndroid) {
      image = imageLib.copyRotate(image, -90);
      image = imageLib.flipHorizontal(image);
    }

    final tensorImage = TensorImage(TfLiteType.float32);
    tensorImage.loadImage(image);
    final inputImage = getProcessedImage(tensorImage);

    TensorBuffer outputLandmarks = TensorBufferFloat(_outputShapes[0]);
    TensorBuffer outputExist = TensorBufferFloat(_outputShapes[1]);
    TensorBuffer outputScores = TensorBufferFloat(_outputShapes[2]);

    final inputs = <Object>[inputImage.buffer];

    final outputs = <int, Object>{
      0: outputLandmarks.buffer,
      1: outputExist.buffer,
      2: outputScores.buffer,
    };

    interpreter.runForMultipleInputs(inputs, outputs);

    if (outputExist.getDoubleValue(0) < exist_threshold ||
        outputScores.getDoubleValue(0) < score_threshold) {
      return null;
    }

    final landmarkPoints = outputLandmarks.getDoubleList().reshape([21, 3]);
    final landmarkResults = <Offset>[];
    for (var point in landmarkPoints) {
      landmarkResults.add(Offset(
        point[0] / input_size * image.width,
        point[1] / input_size * image.height,
      ));
    }

    return {'point': landmarkResults};
  }
}
