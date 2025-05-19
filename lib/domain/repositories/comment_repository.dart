/// 댓글 관련 데이터 액세스 인터페이스 (목록 조회, 작성)

import 'package:flutter_sns_app/domain/entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  Future<void> createComment(String postId, Comment comment);
}