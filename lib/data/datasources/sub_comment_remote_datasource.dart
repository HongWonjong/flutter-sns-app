import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/data/dtos/sub_comment_dto.dart';

class SubCommentRemoteDataSource {
  final FirebaseFirestore _firestore;

  SubCommentRemoteDataSource() : _firestore = FirebaseFirestore.instance;

  Future<List<SubCommentDto>> getSubComments(String postId, String commentId) async {
    final snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('subComments')
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((doc) => SubCommentDto.fromFirestore(doc)).toList();
  }

  Future<void> createSubComment(String postId, String commentId, SubCommentDto subComment) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('subComments')
        .doc(subComment.subCommentId)
        .set(subComment.toFirestore());
  }
}
