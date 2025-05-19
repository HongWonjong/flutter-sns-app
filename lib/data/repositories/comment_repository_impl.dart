/// 댓글 리포지토리 구현체 (Firestore 호출)

import 'package:flutter_sns_app/data/datasources/comment_remote_datasource.dart';
import 'package:flutter_sns_app/data/dtos/comment_dto.dart';
import 'package:flutter_sns_app/domain/entities/comment.dart';
import 'package:flutter_sns_app/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource _dataSource;

  CommentRepositoryImpl(this._dataSource);

  @override
  Future<List<Comment>> getComments(String postId) async {
    final dtos = await _dataSource.getComments(postId);
    return dtos.map((dto) => Comment(
      commentId: dto.commentId,
      text: dto.text,
      createdAt: dto.createdAt,
    )).toList();
  }

  @override
  Future<void> createComment(String postId, Comment comment) async {
    final dto = CommentDto(
      commentId: comment.commentId,
      text: comment.text,
      createdAt: comment.createdAt,
    );
    await _dataSource.createComment(postId, dto);
  }
}