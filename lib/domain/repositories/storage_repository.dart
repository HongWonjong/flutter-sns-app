import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadImage(String postId, File image);
}