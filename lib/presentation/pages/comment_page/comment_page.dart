import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/core/firebase_analytics_service.dart';
import 'package:flutter_sns_app/presentation/pages/comment_page/sub_comment_page.dart';
import 'package:flutter_sns_app/presentation/report/report_dialog.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/comment.dart';
import '../../constants/app_styles.dart';
import '../../providers/comment_provider.dart';
import '../../providers/sub_comment_provider.dart';


class CommentPage extends ConsumerStatefulWidget {
  final String postId;

  const CommentPage({Key? key, required this.postId}) : super(key: key);

  @override
  ConsumerState<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends ConsumerState<CommentPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(commentProvider(widget.postId).notifier).fetchComments();
    });
  }

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newComment = Comment(
      commentId: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
    );

    ref.read(commentProvider(widget.postId).notifier).createComment(newComment);
    _controller.clear();

    FirebaseAnalyticsService.logCommentCreated(postId: widget.postId);
  }

  String _formatDate(DateTime dt) {
    return DateFormat('yy.MM.dd HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentProvider(widget.postId));

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppStyles.backgroundColor,
        elevation: 0,
        title: Text(
          '댓글 ${comments.length}',
          style: AppStyles.titleStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.iconColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppStyles.listBackgroundGradientStart,
                    AppStyles.listBackgroundGradientEnd,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.separated(
                itemCount: comments.length,
                padding: AppStyles.pagePadding,
                separatorBuilder: (_, __) => Container(
                  margin: EdgeInsets.symmetric(vertical: AppStyles.cardSpacing),
                  height: AppStyles.dividerThickness,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppStyles.dividerGradientStart,
                        AppStyles.dividerGradientEnd,
                      ],
                    ),
                    boxShadow: AppStyles.dividerShadow,
                  ),
                ),
                itemBuilder: (_, index) {
                  final comment = comments[index];
                  final subCommentState = ref.watch(subCommentProvider((
                  postId: widget.postId,
                  commentId: comment.commentId,
                  )));

                  // 대댓글 개수 페칭 트리거
                  ref.read(subCommentProvider((
                  postId: widget.postId,
                  commentId: comment.commentId,
                  )).notifier).fetch();

                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => FractionallySizedBox(
                          heightFactor: AppStyles.overlayHeightRatio,
                          child: SubCommentPage(
                            postId: widget.postId,
                            parentComment: comment,
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppStyles.cardBorderRadius),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: AppStyles.cardPadding,
                      margin: EdgeInsets.symmetric(vertical: AppStyles.cardSpacing),
                      decoration: BoxDecoration(
                        color: AppStyles.iconBackgroundColor,
                        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
                        boxShadow: AppStyles.defaultShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  comment.text,
                                  style: AppStyles.commentStyle,
                                ),
                              ),
                              IconButton(icon: Icon(Icons.report), onPressed: () => _showReportDialog(context),)
                            ],
                          ),
                          SizedBox(height: AppStyles.cardSpacing),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _formatDate(comment.createdAt),
                              style: AppStyles.bodyStyle.copyWith(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: AppStyles.cardSpacing),
                            child: Text(
                              '대댓글 ${subCommentState.length}개',
                              style: AppStyles.bodyStyle.copyWith(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: AppStyles.contentPadding,
            decoration: BoxDecoration(
              color: AppStyles.cardBackgroundColor,
              boxShadow: AppStyles.defaultShadow,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppStyles.bodyStyle,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      hintStyle: AppStyles.bodyStyle.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      filled: true,
                      fillColor: AppStyles.tagBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: AppStyles.contentPadding,
                    ),
                  ),
                ),
                SizedBox(width: AppStyles.cardSpacing),
                InkWell(
                  onTap: _submitComment,
                  splashColor: AppStyles.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
                  child: Container(
                    padding: AppStyles.iconPadding,
                    decoration: BoxDecoration(
                      color: AppStyles.iconBackgroundColor,
                      borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
                      boxShadow: AppStyles.defaultShadow,
                    ),
                    child: Icon(
                      Icons.send,
                      color: AppStyles.iconColor,
                      size: AppStyles.iconSizeSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showReportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => ReportDialog(type: 'comment',),
  );
}