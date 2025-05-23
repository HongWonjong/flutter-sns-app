import 'package:flutter_sns_app/domain/repositories/sub_comment_reopsitory.dart';
import '../entities/sub_comment.dart';

class GetSubCommentsUseCase {
  final SubCommentRepository repository;

  GetSubCommentsUseCase(this.repository);

  Future<List<SubComment>> execute(String postId, String commentId) {
    return repository.getSubComments(postId, commentId);
  }
}
