import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/core/firebase_analytics_service.dart';
import 'package:flutter_sns_app/presentation/pages/%08comment_page/sub_comment_page.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/comment.dart';
import '../../providers/comment_provider.dart';

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
      appBar: AppBar(
        title: Text('댓글 ${comments.length}'),
        leading: BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: comments.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (_, index) {
                final comment = comments[index];
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder:
                          (context) => FractionallySizedBox(
                            heightFactor: 0.8,
                            child: SubCommentPage(parentComment: comment),
                          ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.text, style: TextStyle(fontSize: 16)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _formatDate(comment.createdAt),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _submitComment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
