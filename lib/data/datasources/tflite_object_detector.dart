import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../../core/yolo_detection.dart';
import '../repositories/object_detection_repository.dart';

class TFLiteObjectDetector implements ObjectDetectionRepository {
  final YoloDetection _yoloDetection;

  TFLiteObjectDetector() : _yoloDetection = YoloDetection() {
    _yoloDetection.initialize();
  }

  @override
  Future<bool> hasNoPerson(XFile image) async {
    final imageBytes = await image.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes)!;
    final detectedObjects = _yoloDetection.runInference(decodedImage);
    return !detectedObjects.any(
          (obj) => _yoloDetection.label(obj.labelIndex).toLowerCase() == 'person',
    );
  }
}

final objectDetectionRepositoryProvider = Provider<ObjectDetectionRepository>((ref) {
  return TFLiteObjectDetector();
});