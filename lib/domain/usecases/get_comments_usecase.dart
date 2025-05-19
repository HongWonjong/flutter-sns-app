/// 댓글 목록 가져오기 유스케이스
import 'package:flutter_sns_app/domain/entities/comment.dart';
import 'package:flutter_sns_app/domain/repositories/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository _repository;

  GetCommentsUseCase(this._repository);

  Future<List<Comment>> execute(String postId) {
    return _repository.getComments(postId);
  }
}