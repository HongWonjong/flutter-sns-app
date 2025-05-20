import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/data/datasources/post_remote_datasource.dart';
import 'package:flutter_sns_app/data/datasources/storage_datasource.dart';
import 'package:flutter_sns_app/data/repositories/post_repository_impl.dart';
import 'package:flutter_sns_app/data/repositories/storage_repository_impl.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/domain/repositories/post_repository.dart';
import 'package:flutter_sns_app/domain/repositories/storage_repository.dart';
import 'package:flutter_sns_app/domain/usecases/create_post_usecase.dart';
import 'package:flutter_sns_app/domain/usecases/get_posts_usecase.dart';

class PostProvider extends StateNotifier<List<Post>> {
  final GetPostsUseCase _getPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  PostProvider(this._getPostsUseCase, this._createPostUseCase) : super([]);

  Future<void> fetchPosts() async {
    if (!_hasMore) return;
    try {
      final newPosts = await _getPostsUseCase.execute(10, _lastDocument);
      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        state = [...state, ...newPosts];
      }
    } catch (e) {
      print('게시물 가져오기 실패: $e');
      rethrow;
    }
  }

  Future<void> createPost({
    required File imageFile,
    required String text,
    required List<String> tags,
  }) async {
    try {
      await _createPostUseCase.execute(
        imageFile: imageFile,
        text: text,
        tags: tags,
      );
      await fetchPosts();
    } catch (e) {
      print('게시물 생성 실패: $e');
      rethrow;
    }
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
  return CreatePostUseCase(
    ref.watch(postRepositoryProvider),
    ref.watch(storageRepositoryProvider),
  );
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(ref.watch(postRemoteDataSourceProvider));
});

final postRemoteDataSourceProvider = Provider<PostRemoteDataSource>((ref) {
  return PostRemoteDataSource();
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepositoryImpl(ref.watch(storageDataSourceProvider));
});

final storageDataSourceProvider = Provider<StorageDataSource>((ref) {
  return StorageDataSource();
});