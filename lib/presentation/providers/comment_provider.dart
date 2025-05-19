/// 댓글 상태 관리: 목록 로드, 작성
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/domain/entities/comment.dart';
import 'package:flutter_sns_app/domain/usecases/create_comment_usecase.dart';
import 'package:flutter_sns_app/domain/usecases/get_comments_usecase.dart';

import '../../data/datasources/comment_remote_datasource.dart';
import '../../data/repositories/comment_repository_impl.dart';
import '../../domain/repositories/comment_repository.dart';

class CommentProvider extends StateNotifier<List<Comment>> {
  final GetCommentsUseCase _getCommentsUseCase;
  final CreateCommentUseCase _createCommentUseCase;
  final String postId;

  CommentProvider(this._getCommentsUseCase, this._createCommentUseCase, this.postId) : super([]);

  Future<void> fetchComments() async {
    final comments = await _getCommentsUseCase.execute(postId);
    state = comments;
  }

  Future<void> createComment(Comment comment) async {
    await _createCommentUseCase.execute(postId, comment);
    state = [...state, comment]; // 새 댓글 추가
  }
}

final commentProvider = StateNotifierProvider.family<CommentProvider, List<Comment>, String>((ref, postId) {
  final getCommentsUseCase = ref.watch(getCommentsUseCaseProvider);
  final createCommentUseCase = ref.watch(createCommentUseCaseProvider);
  return CommentProvider(getCommentsUseCase, createCommentUseCase, postId);
});

final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) {
  return GetCommentsUseCase(ref.watch(commentRepositoryProvider));
});

final createCommentUseCaseProvider = Provider<CreateCommentUseCase>((ref) {
  return CreateCommentUseCase(ref.watch(commentRepositoryProvider));
});

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepositoryImpl(ref.watch(commentRemoteDataSourceProvider));
});

final commentRemoteDataSourceProvider = Provider<CommentRemoteDataSource>((ref) {
  return CommentRemoteDataSource();
});