/// 게시물 작성 유스케이스 (이미지 검사 후 업로드 로직 필요)
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/domain/repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _repository;

  CreatePostUseCase(this._repository);

  Future<void> execute(Post post) {
    return _repository.createPost(post);
  }
}