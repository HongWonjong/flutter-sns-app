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
import 'package:flutter_sns_app/domain/usecases/get_posts_by_tag_usecase.dart';

class PostProvider extends StateNotifier<List<Post>> {
  final GetPostsUseCase _getPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  final GetPostsByTagUseCase _getPostsByTagUseCase;
  DocumentSnapshot? _lastDocument;
  DocumentSnapshot? _lastSearchDocument;
  bool _hasMore = true;
  bool _hasMoreSearch = true;

  PostProvider(this._getPostsUseCase, this._createPostUseCase, this._getPostsByTagUseCase) : super([]);

  Future<void> fetchPosts() async {
    if (!_hasMore) return;
    try {
      print('fetchPosts 호출: lastDocument=$_lastDocument');
      final newPosts = await _getPostsUseCase.execute(10, _lastDocument);
      print('가져온 게시물 수: ${newPosts.length}');
      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        _lastDocument = await _getLastDocument(newPosts);
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
      state = [];
      _lastDocument = null;
      _lastSearchDocument = null;
      _hasMore = true;
      _hasMoreSearch = true;
      await fetchPosts();
    } catch (e) {
      print('게시물 생성 실패: $e');
      rethrow;
    }
  }

  Future<void> searchPostsByTag(String tag) async {
    try {
      print('searchPostsByTag 호출: tag=$tag, lastSearchDocument=$_lastSearchDocument');
      final newPosts = await _getPostsByTagUseCase.execute(tag, 10, _lastSearchDocument);
      print('검색된 게시물 수: ${newPosts.length}');
      if (newPosts.isEmpty) {
        _hasMoreSearch = false;
      } else {
        _lastSearchDocument = await _getLastDocument(newPosts);
        state = [...state, ...newPosts];
      }
    } catch (e) {
      print('태그로 게시물 검색 실패: $e');
      rethrow;
    }
  }

  Future<void> resetSearch() async {
    state = [];
    _lastDocument = null;
    _lastSearchDocument = null;
    _hasMore = true;
    _hasMoreSearch = true;
    await fetchPosts();
  }

  Future<DocumentSnapshot?> _getLastDocument(List<Post> posts) async {
    if (posts.isEmpty) return null;
    final lastPost = posts.last;
    final snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(lastPost.postId)
        .get();
    return snapshot;
  }
}

final postProvider = StateNotifierProvider<PostProvider, List<Post>>((ref) {
  final getPostsUseCase = ref.watch(getPostsUseCaseProvider);
  final createPostUseCase = ref.watch(createPostUseCaseProvider);
  final getPostsByTagUseCase = ref.watch(getPostsByTagUseCaseProvider);
  return PostProvider(getPostsUseCase, createPostUseCase, getPostsByTagUseCase);
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

final getPostsByTagUseCaseProvider = Provider<GetPostsByTagUseCase>((ref) {
  return GetPostsByTagUseCase(ref.watch(postRepositoryProvider));
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