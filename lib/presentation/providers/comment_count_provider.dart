import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/providers/post_provider.dart';
import '../../domain/usecases/get_comment_count_usecase.dart';


final getCommentCountUseCaseProvider = Provider<GetCommentCountUseCase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return GetCommentCountUseCase(repository);
});