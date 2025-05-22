import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/domain/repositories/post_repository.dart';

class GetPostsByTagUseCase {
  final PostRepository _repository;

  GetPostsByTagUseCase(this._repository);

  Future<List<Post>> execute(String tag, int limit, DocumentSnapshot? startAfter) {
    return _repository.searchPostsByTag(tag, limit, startAfter);
  }
}