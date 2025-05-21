/// 게시물 리포지토리 구현체 (Firestore 호출, 이미지 검사 포함)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/data/datasources/post_remote_datasource.dart';
import 'package:flutter_sns_app/data/dtos/post_dto.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _dataSource;

  PostRepositoryImpl(this._dataSource);

  @override
  Future<List<Post>> getPosts(int limit, DocumentSnapshot? startAfter) async {
    final dtos = await _dataSource.getPosts(limit, startAfter);
    return dtos.map((dto) => Post(
      postId: dto.postId,
      imageUrl: dto.imageUrl,
      text: dto.text,
      tags: dto.tags,
      createdAt: dto.createdAt,
      likes: [],
    )).toList();
  }

  @override
  Future<int> getCommentCount(String postId) async {
    return await _dataSource.getCommentCount(postId);
  }

  Future<int> getLikesCount(String postId) async {
    return await _dataSource.getLikesCount(postId);
  }

  @override
  Future<void> createPost(Post post) async {
    final dto = PostDto(
      postId: post.postId,
      imageUrl: post.imageUrl,
      text: post.text,
      tags: post.tags,
      createdAt: post.createdAt,
    );
    await _dataSource.createPost(dto);
  }
  @override
  Future<List<Post>> searchPostsByTag(String tag, int limit, DocumentSnapshot? startAfter) async {
    final dtos = await _dataSource.searchPostsByTag(tag, limit, startAfter);
    return dtos.map((dto) => Post(
      postId: dto.postId,
      imageUrl: dto.imageUrl,
      text: dto.text,
      tags: dto.tags,
      createdAt: dto.createdAt,
      likes: [],
    )).toList();
  }
}