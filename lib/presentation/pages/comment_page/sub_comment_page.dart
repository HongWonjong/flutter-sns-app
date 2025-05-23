import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/comment.dart';
import '../../../domain/entities/sub_comment.dart';
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.parentComment.text, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  _formatDate(widget.parentComment.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: subComments.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade300),
              itemBuilder: (_, index) {
                final reply = subComments[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 24, right: 16, top: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reply.text),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _formatDate(reply.createdAt),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      )
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
                      hintText: '대댓글을 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _submitSubComment,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}//