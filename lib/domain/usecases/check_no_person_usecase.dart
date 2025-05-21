import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasources/tflite_object_detector.dart';
import '../../data/repositories/object_detection_repository.dart';

class CheckNoPersonUseCase {
  final ObjectDetectionRepository _repository;

  CheckNoPersonUseCase(this._repository);

  Future<bool> execute(XFile image) async {
    return await _repository.hasNoPerson(image);
  }
}

final checkNoPersonUseCaseProvider = Provider<CheckNoPersonUseCase>((ref) {
  final repository = ref.watch(objectDetectionRepositoryProvider);
  return CheckNoPersonUseCase(repository);
});