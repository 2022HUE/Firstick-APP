import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:chopstick2/services/locator.dart';
import 'package:chopstick2/services/inference_service.dart';
import './handpainter.dart';

class Preview extends StatelessWidget {
  Preview({
    required this.controller,
    required this.draw,
    Key? key,
  }) : super(key: key);

  final CameraController? controller;
  final bool draw;

  late final double deviceRatio;
  final Map<String, dynamic>? inferenceResults =
      locator<InferenceService>().inferenceResults;

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    deviceRatio = size.width / controller!.value.previewSize!.height;

    return Stack(
      children: [
        CameraPreview(controller!),
        Visibility(
          visible: draw,
          child: _drawHands,
        ),
      ],
    );
  }

  Widget get _drawHands => _Painter(
        customPainter: HandsPainter(
          points: inferenceResults?['point'] ?? [],
          ratio: deviceRatio,
        ),
      );
}

class _Painter extends StatelessWidget {
  _Painter({
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
