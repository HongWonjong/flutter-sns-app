import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/comment.dart';
import '../../../domain/entities/sub_comment.dart';
import '../../constants/app_styles.dart';
import '../../providers/sub_comment_provider.dart';

class SubCommentPage extends ConsumerStatefulWidget {
  final String postId;
  final Comment parentComment;

  const SubCommentPage({
    Key? key,
    required this.postId,
    required this.parentComment,
  }) : super(key: key);

  @override
  ConsumerState<SubCommentPage> createState() => _SubCommentPageState();
}

class _SubCommentPageState extends ConsumerState<SubCommentPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(subCommentProvider((
      postId: widget.postId,
      commentId: widget.parentComment.commentId,
      )).notifier)
          .fetch();
    });
  }

  void _submitSubComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final subComment = SubComment(
      subCommentId: DateTime.now().millisecondsSinceEpoch.toString(),
      commentId: widget.parentComment.commentId,
      text: text,
      createdAt: DateTime.now(),
    );

    ref
        .read(subCommentProvider((
    postId: widget.postId,
    commentId: widget.parentComment.commentId,
    )).notifier)
        .create(subComment);

    _controller.clear();
  }

  String _formatDate(DateTime dt) {
    return DateFormat('yy.MM.dd HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final subComments = ref.watch(subCommentProvider((
    postId: widget.postId,
    commentId: widget.parentComment.commentId,
    )));

    return Scaffold(
      backgroundColor: AppStyles.cardBackgroundColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: AppStyles.cardPadding,
            margin: EdgeInsets.only(bottom: AppStyles.cardSpacing),
            decoration: BoxDecoration(
              color: AppStyles.tagBackgroundColor,
              boxShadow: AppStyles.defaultShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.parentComment.text,
                  style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AppStyles.cardSpacing),
                Text(
                  _formatDate(widget.parentComment.createdAt),
                  style: AppStyles.bodyStyle.copyWith(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
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
                itemCount: subComments.length,
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
                  final reply = subComments[index];
                  return Container(
                    padding: AppStyles.cardPadding,
                    margin: EdgeInsets.only(left: 16, bottom: AppStyles.cardSpacing),
                    decoration: BoxDecoration(
                      color: AppStyles.iconBackgroundColor,
                      borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
                      boxShadow: AppStyles.defaultShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reply.text,
                          style: AppStyles.bodyStyle,
                        ),
                        SizedBox(height: AppStyles.cardSpacing),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _formatDate(reply.createdAt),
                            style: AppStyles.bodyStyle.copyWith(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
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
                      hintText: '대댓글을 입력하세요',
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
                  onTap: _submitSubComment,
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