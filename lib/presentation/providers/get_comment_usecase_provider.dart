import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_comments_usecase.dart';
import 'comment_provider.dart';
import 'comment_repository_provider.dart';

final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) {
  return GetCommentsUseCase(ref.watch(commentRepositoryProvider));
});