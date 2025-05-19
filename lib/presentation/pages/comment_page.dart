import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/comment.dart';

class CommentPage extends StatefulWidget {
  final List<Comment> comments;

  const CommentPage({Key? key, required this.comments}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Comment> _commentList = [];

  @override
  void initState() {
    super.initState();
    _commentList.addAll(widget.comments);
  }

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newComment = Comment(
      commentId: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now(),
    );

    setState(() {
      _commentList.add(newComment);
      _controller.clear();
    });
  }

  String _formatDate(DateTime dt) {
    return DateFormat('yy.MM.dd HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('댓글 ${_commentList.length}'),
        leading: BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _commentList.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (_, index) {
                final comment = _commentList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.text,
                      style: TextStyle(fontSize: 16),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _formatDate(comment.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    )
                  ],
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
                          vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _submitComment,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
