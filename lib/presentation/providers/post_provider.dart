/// 게시물 상태 관리: 목록 로드, 새로고침, 작성 (이미지 검사 포함)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/domain/usecases/create_post_usecase.dart';
import 'package:flutter_sns_app/domain/usecases/get_posts_usecase.dart';

import '../../data/datasources/post_remote_datasource.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/repositories/post_repository.dart';

class PostProvider extends StateNotifier<List<Post>> {
  final GetPostsUseCase _getPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  PostProvider(this._getPostsUseCase, this._createPostUseCase) : super([]);

  Future<void> fetchPosts() async {
    if (!_hasMore) return;
    final newPosts = await _getPostsUseCase.execute(10, _lastDocument);
    if (newPosts.isEmpty) {
      _hasMore = false;
    } else {
      _lastDocument = newPosts.last as DocumentSnapshot?;
      state = [...state, ...newPosts];
    }
  }

  Future<void> createPost(Post post) async {
    await _createPostUseCase.execute(post);
    state = [post, ...state]; // 새 게시물 추가
  }
}

final postProvider = StateNotifierProvider<PostProvider, List<Post>>((ref) {
  final getPostsUseCase = ref.watch(getPostsUseCaseProvider);
  final createPostUseCase = ref.watch(createPostUseCaseProvider);
  return PostProvider(getPostsUseCase, createPostUseCase);
});

final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  return GetPostsUseCase(ref.watch(postRepositoryProvider));
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  return CreatePostUseCase(ref.watch(postRepositoryProvider));
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(ref.watch(postRemoteDataSourceProvider));
});

final postRemoteDataSourceProvider = Provider<PostRemoteDataSource>((ref) {
  return PostRemoteDataSource();
});