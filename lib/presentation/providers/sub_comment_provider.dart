import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/domain/entities/sub_comment.dart';
import 'package:flutter_sns_app/domain/repositories/sub_comment_reopsitory.dart';
import 'package:flutter_sns_app/domain/usecases/create_sub_comment_usecase.dart';
import 'package:flutter_sns_app/domain/usecases/get_sub_comments_usecase.dart';
import '../../data/datasources/sub_comment_remote_datasource.dart';
import '../../data/repositories/sub_comment_repository_impl.dart';

class SubCommentProvider extends StateNotifier<List<SubComment>> {
  final GetSubCommentsUseCase _getUseCase;
  final CreateSubCommentUseCase _createUseCase;
  final String postId;
  final String commentId;

  SubCommentProvider(
    this._getUseCase,
    this._createUseCase,
    this.postId,
    this.commentId,
  ) : super([]);

  Future<void> fetch() async {
    final subComments = await _getUseCase.execute(postId, commentId);
    state = subComments;
  }

  Future<void> create(SubComment subComment) async {
    await _createUseCase.execute(postId, commentId, subComment);
    state = [...state, subComment];
  }
}
final subCommentRemoteDataSourceProvider = Provider<SubCommentRemoteDataSource>((ref) {
  return SubCommentRemoteDataSource();
});

final subCommentRepositoryProvider = Provider<SubCommentRepository>((ref) {
  return SubCommentRepositoryImpl(ref.watch(subCommentRemoteDataSourceProvider));
});

final getSubCommentsUseCaseProvider = Provider<GetSubCommentsUseCase>((ref) {
  return GetSubCommentsUseCase(ref.watch(subCommentRepositoryProvider));
});
final createSubCommentUseCaseProvider = Provider<CreateSubCommentUseCase>((ref) {
  return CreateSubCommentUseCase(ref.watch(subCommentRepositoryProvider));
});

final subCommentProvider = StateNotifierProvider.family<SubCommentProvider, List<SubComment>, ({String postId, String commentId})>((ref, args) {
  return SubCommentProvider(
    ref.watch(getSubCommentsUseCaseProvider),
    ref.watch(createSubCommentUseCaseProvider),
    args.postId,
    args.commentId,
  );
});
