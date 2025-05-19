import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static final FirebaseStorageService _instance = FirebaseStorageService._internal();
  final FirebaseStorage _storage;

  factory FirebaseStorageService() {
    return _instance;
  }

  FirebaseStorageService._internal() : _storage = FirebaseStorage.instance;

  FirebaseStorage get storage => _storage;
}