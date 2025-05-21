import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/create_comment_usecase.dart';
import 'comment_provider.dart';
import 'comment_repository_provider.dart';

final createCommentUseCaseProvider = Provider<CreateCommentUseCase>((ref) {
  return CreateCommentUseCase(ref.watch(commentRepositoryProvider));
});