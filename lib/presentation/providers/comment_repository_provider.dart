import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/comment_repository_impl.dart';
import '../../domain/repositories/comment_repository.dart';
import 'comment_provider.dart';
import 'comment_remote_datasource_provider.dart';

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepositoryImpl(ref.watch(commentRemoteDataSourceProvider));
});