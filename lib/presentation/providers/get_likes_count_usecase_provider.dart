import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/domain/usecases/get_likes_count_usecase.dart';
import 'package:flutter_sns_app/presentation/providers/post_provider.dart';


final getLikesCountUseCaseProvider = Provider<GetLikesCountUsecase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return GetLikesCountUsecase(repository);
});