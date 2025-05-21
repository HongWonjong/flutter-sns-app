import 'package:image_picker/image_picker.dart';

abstract class ObjectDetectionRepository {
  Future<bool> hasNoPerson(XFile image);
}