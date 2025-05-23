import 'package:flutter_sns_app/data/datasources/sub_comment_remote_datasource.dart';
import 'package:flutter_sns_app/data/dtos/sub_comment_dto.dart';
import 'package:flutter_sns_app/domain/entities/sub_comment.dart';
import 'package:flutter_sns_app/domain/repositories/sub_comment_reopsitory.dart';

class SubCommentRepositoryImpl implements SubCommentRepository {
  final SubCommentRemoteDataSource _dataSource;

  SubCommentRepositoryImpl(this._dataSource);

  @override
  Future<List<SubComment>> getSubComments(String postId, String commentId) async {
    final dtos = await _dataSource.getSubComments(postId, commentId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> createSubComment(String postId, String commentId, SubComment comment) {
    final dto = SubCommentDto.fromEntity(comment);
    return _dataSource.createSubComment(postId, commentId, dto);
  }
}
