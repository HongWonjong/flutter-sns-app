/// 게시물 목록 가져오기 유스케이스
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/domain/repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository _repository;

  GetPostsUseCase(this._repository);

  Future<List<Post>> execute(int limit, DocumentSnapshot? startAfter) {
    return _repository.getPosts(limit, startAfter);
  }
}