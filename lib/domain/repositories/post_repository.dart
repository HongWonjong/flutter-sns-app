/// 게시물 관련 데이터 액세스 인터페이스 (목록 조회, 작성)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';

abstract class PostRepository {
  Future<int> getLikesCount(String postId);
  Future<int> getCommentCount(String postId);
  Future<List<Post>> getPosts(int limit, DocumentSnapshot? startAfter);
  Future<void> createPost(Post post);
  Future<List<Post>> searchPostsByTag(String tag, int limit, DocumentSnapshot? startAfter);
}