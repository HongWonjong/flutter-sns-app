import 'dart:io';

import 'package:flutter_sns_app/data/datasources/storage_datasource.dart';
import 'package:flutter_sns_app/domain/repositories/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository{
  final StorageDataSource _dataSource;

  StorageRepositoryImpl(this._dataSource);

  @override
  Future<String> uploadImage(String postId, File image) {
    return _dataSource.uploadImage(postId, image);
  }
}