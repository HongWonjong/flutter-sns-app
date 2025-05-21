/// 게시물 작성 유스케이스 (이미지 검사 후 업로드 로직 필요)
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/domain/repositories/post_repository.dart';
import 'package:flutter_sns_app/domain/repositories/storage_repository.dart';
import 'package:uuid/uuid.dart';

class CreatePostUseCase {
  final PostRepository _repository;
  final StorageRepository _storageRepository;

  CreatePostUseCase(this._repository, this._storageRepository);

  Future<Post> execute({
    required imageFile,
    required text,
    required List<String> tags,
  }) async {
    final postId = Uuid().v4();
    final imageUrl = await _storageRepository.uploadImage(postId, imageFile);
    final post = Post(
        postId: postId,
        text: text,
        tags: tags,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      await _repository.createPost(post);
      return post;
  }
}
