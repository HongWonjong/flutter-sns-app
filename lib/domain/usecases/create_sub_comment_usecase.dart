import 'package:flutter_sns_app/domain/repositories/sub_comment_reopsitory.dart';
import '../entities/sub_comment.dart';

class CreateSubCommentUseCase {
  final SubCommentRepository repository;

  CreateSubCommentUseCase(this.repository);

  Future<void> execute(String postId, String commentId, SubComment comment) {
    return repository.createSubComment(postId, commentId, comment);
  }
}
