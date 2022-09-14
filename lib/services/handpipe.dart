import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../setting/models.dart';
import '../setting/labels.dart';
import '../utils/image_utils.dart';

class Handpipe {
  Handpipe({this.interpreter}) {
    // debugPrint('Hello Handpipe');
    loadModel();
    // loadLabels();
    // debugPrint(interpreter.toString());
  }

  // init
  final int inputSize = 224;
  final double existThreshold = 0.1;
  final double scoreThreshold = 0.3;

  // Shapes/Types of output tensors
  late List<List<int>> outputShapes;
  late List<TfLiteType> outputTypes;

  // @override
  Interpreter? interpreter;
  // Interpreter? chs_model; // chopsticks model interpreter
  // List<String>? chs_label; // chopsticks model labels

  // @override
  List<Object> get props => [];

  // @override
  int get getAddress => interpreter!.address;

  /// Loads interpreter from asset
  Future<void> loadModel() async {
    // debugPrint('loadModel_Handpipe');

    try {
      final interpreterOptions = InterpreterOptions();

      interpreter ??= await Interpreter.fromAsset(Models.handpipe,
          options: interpreterOptions);
      // chs_model ??= await Interpreter.fromAsset(Models.modelChopsticks,
      //     options: interpreterOptions);

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

  // void loadLabels() async {
  //   try {
  //     chs_label = await FileUtil.loadLabels(Labels.labelChopsticks);
  //   } catch (e) {
  //     debugPrint("Error while loading labels: $e");
  //   }
  // }

  /// Pre-process the image
  TensorImage getProcessedImage(TensorImage inputImage) {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  // // Create a container for the result and specify that this is a quantized model.
  // // Hence, the 'DataType' is defined as UINT8 (8-bit unsigned integer)
  // TensorBuffer probabilityBuffer =
  //     TensorBuffer.createFixedSize(<int>[1, 1001], TfLiteType.uint8);

  // Map<String, dynamic>? chs_predict(imageLib.Image image, data) {
  //   if (chs_model == null) {
  //     debugPrint('[!] Chopsticks - Interpreter is null');
  //     return null;
  //   }
  //   final tensorImage = TensorImage(TfLiteType.float32);
  //   tensorImage.loadImage(image);
  //   // final inputImage = getProcessedImage(tensorImage);

  //   // chs_model?.run(tensorImage.buffer, probabilityBuffer.buffer);
  //   // chs_model?.run(data.buffer, probabilityBuffer.buffer);
  //   final res = probabilityBuffer.getDoubleList();
  //   debugPrint(res.toString());
  //   return {'prob': res};
  // }

  /// Runs object detection on the input image
  Map<String, dynamic>? predict(imageLib.Image image) {
    // Interpreter? interpreter;
    debugPrint(interpreter.toString());

    if (interpreter == null) {
      debugPrint('[!] Handpipe - Interpreter is null');
      return null;
    }

    if (Platform.isAndroid) {
      // 카메라 방향 270도로 바꾸기 -90
      image = imageLib.copyRotate(image, -90);
      // 반전 시키기
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

    final landmarkPoints = outputLandmarks
        .getDoubleList()
        .reshape([21, 3]); // [[x1, y1, z1], [x2, ...]]

    // chopsticks model에 맞춰 data 수정
    final p_ = landmarkPoints; // copy
    final handRow =
        outputLandmarks.getDoubleList().reshape([63]); // [x1, y1, z1, x2, ...]
    final handRowData = [
      p_[16][1] - p_[12][1],
      p_[15][1] - p_[11][1],
      p_[16][1] - p_[8][1],
      p_[15][1] - p_[7][1]
    ];
    for (var data in handRowData) {
      handRow.add(data);
    }

    // chs_predict(image, handRow);

    final landmarkResults = <Offset>[];
    for (var point in landmarkPoints) {
      landmarkResults.add(Offset(
        point[0] / inputSize * image.width,
        point[1] / inputSize * image.height,
      ));
    }

    var cnt = 0;
    var hand1 = [];
    var hand2 = [];
    for (var data in handRow) {
      if (cnt < 32) {
        hand1.add(data);
      } else {
        hand2.add(data);
      }
      cnt += 1;
    }

    // debugPrint(hand1.toString());
    // debugPrint('---------------');
    // debugPrint(hand2.toString());

    final open_data = [
      184.04269409179688,
      158.37989807128906,
      -3.7885774872847833e-7,
      155.36993408203125,
      131.54710388183594,
      -9.354488372802734,
      130.21578979492188,
      98.29399871826172,
      -9.910565376281738,
      108.60450744628906,
      75.47925567626953,
      -8.882486343383789,
      89.2557601928711,
      56.83169174194336,
      -7.649709701538086,
      158.2884979248047,
      63.09287643432617,
      2.871729850769043,
      120.46647644042969,
      46.491031646728516,
      3.2110798358917236,
      96.03971099853516,
      44.96442413330078,
      1.1403303146362305,
      73.3350830078125,
      47.94139099121094,
      -0.16673099994659424,
      158.28712463378906,
      70.71769714355469,
      8.436884880065918,
      117.61058807373047,
      63.80081558227539,
      8.968266487121582,
      95.81289672851562,
      67.67229461669922,
      4.265143394470215,
      77.3279037475586,
      75.03742218017578,
      1.0578380823135376,
      154.86184692382812,
      82.7362060546875,
      12.8318452835083,
      116.52687072753906,
      78.59619903564453,
      11.780406951904297,
      104.1015625,
      87.5924072265625,
      5.816107749938965,
      94.31775665283203,
      98.20278930664062,
      2.314042568206787,
      149.5555419921875,
      97.67398834228516,
      16.508197784423828,
      117.88965606689453,
      93.45669555664062,
      15.322624206542969,
      106.43939208984375,
      96.06243896484375,
      11.776567459106445,
      97.62760162353516,
      100.42536926269531,
      9.552566528320312,
      23.165367126464844,
      19.92011260986328,
      50.26139831542969,
      42.62798309326172
    ];

    final close_data = [
      182.87200927734375,
      170.82211303710938,
      0.0000010817630027304403,
      155.14691162109375,
      137.5908203125,
      -8.409655570983887,
      127.7627944946289,
      108.45536804199219,
      -6.86320686340332,
      102.10436248779297,
      88.9314193725586,
      -3.729154348373413,
      80.67266845703125,
      77.0695571899414,
      -0.4333164691925049,
      149.9582977294922,
      72.5093994140625,
      8.311524391174316,
      112.75738525390625,
      66.36415100097656,
      11.159881591796875,
      90.08094787597656,
      70.52621459960938,
      9.76893424987793,
      70.34935760498047,
      78.39108276367188,
      8.692928314208984,
      145.7867889404297,
      83.9737777709961,
      14.653194427490234,
      110.36808013916016,
      81.99828338623047,
      17.499858856201172,
      90.11653900146484,
      87.98114776611328,
      11.690857887268066,
      73.15572357177734,
      99.73802185058594,
      7.337373733520508,
      141.34425354003906,
      98.21226501464844,
      19.827423095703125,
      108.30027770996094,
      96.35649108886719,
      19.684900283813477,
      94.2869873046875,
      101.83467102050781,
      10.8307466506958,
      82.54776000976562,
      111.72449493408203,
      5.197752475738525,
      137.01699829101562,
      113.3287582397461,
      24.554059982299805,
      108.93338775634766,
      109.72372436523438,
      23.351661682128906,
      98.68348693847656,
      111.62843322753906,
      18.00241470336914,
      90.23359680175781,
      117.09673309326172,
      14.274688720703125,
      11.986473083496094,
      13.853523254394531,
      33.333412170410156,
      31.308456420898438
    ];
    int open_cnt = 0;
    int close_cnt = 0;
    double diff = 0;
    for (int i = 0; i < handRow.length; i++) {
      double o_diff = (open_data[i] - handRow[i]).abs();
      double c_diff = (close_data[i] - handRow[i]).abs();
      if (o_diff < c_diff) {
        open_cnt += 1;
      } else {
        close_cnt += 1;
      }
      diff += o_diff;
    }
    debugPrint('----------res-----predict---------');
    debugPrint(diff.toString());
    debugPrint(handRowData.toString());
    if (open_cnt > close_cnt) {
      debugPrint('RES: OPEN');
    } else {
      debugPrint('RES: CLOSE');
    }

    // debugPrint(outputLandmarks.getDoubleList().length.toString());
    return {'point': landmarkResults, 'diff': diff};
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

  debugPrint(res.toString());

  return res;
}
