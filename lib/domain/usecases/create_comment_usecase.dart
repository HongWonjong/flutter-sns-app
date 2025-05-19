/// 댓글 작성 유스케이스
import 'package:flutter_sns_app/domain/entities/comment.dart';
import 'package:flutter_sns_app/domain/repositories/comment_repository.dart';

class CreateCommentUseCase {
  final CommentRepository _repository;

  CreateCommentUseCase(this._repository);

  Future<void> execute(String postId, Comment comment) {
    return _repository.createComment(postId, comment);
  }
}