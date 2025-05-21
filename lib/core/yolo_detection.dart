import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:yolo_helper/yolo_helper.dart';

class YoloDetection {
  int? _numClasses;
  List<String>? _labels;
  Interpreter? _interpreter;

  String label(int index) => _labels?[index] ?? '';

  bool get isInitialized => _interpreter != null && _labels != null;

  Future<void> initialize() async {
    _interpreter = await Interpreter.fromAsset('assets/yolov8n.tflite');
    final labelAsset = await rootBundle.loadString('assets/labels.txt');
    _labels = labelAsset.split('\n');
    _numClasses = _labels!.length;
  }

  List<DetectedObject> runInference(Image image) {
    if (!isInitialized) {
      throw Exception('The model must be initialized');
    }

    final imgResized = copyResize(image, width: 640, height: 640);

    final imgNormalized = List.generate(
      640,
          (y) => List.generate(
        640,
            (x) {
          final pixel = imgResized.getPixel(x, y);
          return [pixel.rNormalized, pixel.gNormalized, pixel.bNormalized];
        },
      ),
    );

    final output = [
      List<List<double>>.filled(4 + _numClasses!, List<double>.filled(8400, 0))
    ];
    _interpreter!.run([imgNormalized], output);
    return YoloHelper.parse(output[0], image.width, image.height);
  }
}