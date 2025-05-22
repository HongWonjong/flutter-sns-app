import 'package:flutter_sns_app/domain/repositories/post_repository.dart';
class GetCommentCountUseCase {
  final PostRepository _repository;

  GetCommentCountUseCase(this._repository);

  Future<int> execute(String postId) {
    return _repository.getCommentCount(postId);
  }
}