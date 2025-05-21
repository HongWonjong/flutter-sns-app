/// Firestore에서 게시물 데이터 가져오기/작성
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/data/dtos/post_dto.dart';
import '../../services/firebase_firestore_service.dart';

class PostRemoteDataSource {
  final FirebaseFirestore _firestore;

  PostRemoteDataSource() : _firestore = FirebaseFirestoreService().firestore;

  Future<List<PostDto>> getPosts(int limit, DocumentSnapshot? startAfter) async {
    Query query = _firestore.collection('posts').orderBy('createdAt', descending: true).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => PostDto.fromFirestore(doc)).toList();
  }

  Future<void> createPost(PostDto post) async {
    await _firestore.collection('posts').doc(post.postId).set(post.toFirestore());
  }
  Future<List<PostDto>> searchPostsByTag(String tag, int limit, DocumentSnapshot? startAfter) async {
    Query query = _firestore.collection('posts')
        .where('tags', arrayContains: tag)
        .orderBy('createdAt', descending: true)
        .limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => PostDto.fromFirestore(doc)).toList();
  }
}