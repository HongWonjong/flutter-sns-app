/// Firestore에서 댓글 데이터 가져오기/작성
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/data/dtos/comment_dto.dart';

class CommentRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CommentDto>> getComments(String postId) async {
    final snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt')
        .get();
    return snapshot.docs.map((doc) => CommentDto.fromFirestore(doc)).toList();
  }

  Future<void> createComment(String postId, CommentDto comment) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment.commentId)
        .set(comment.toFirestore());
  }
}
