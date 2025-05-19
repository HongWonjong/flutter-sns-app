/// Firebase Storage에서 이미지 업로드/URL 가져오기 (검사 후 업로드)
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(String postId, File image) async {
    final fileName = Uuid().v4();
    final ref = _storage.ref().child('images').child(postId).child('$fileName.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}