import 'package:flutter_sns_app/domain/repositories/post_repository.dart';

class GetLikesCountUsecase {
  final PostRepository _repository;

  GetLikesCountUsecase(this._repository);

  Future<int> execute (String postId) {
    return _repository.getLikesCount(postId);
  }
}