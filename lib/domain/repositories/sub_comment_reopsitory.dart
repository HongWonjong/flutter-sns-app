import 'package:flutter_sns_app/domain/entities/sub_comment.dart';

abstract class SubCommentRepository {
  Future<List<SubComment>> getSubComments(String postId, String commentId);
  Future<void> createSubComment(String postId, String commentId, SubComment comment);
}
