import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/comment_remote_datasource.dart';

final commentRemoteDataSourceProvider = Provider<CommentRemoteDataSource>((ref) {
  return CommentRemoteDataSource();
});