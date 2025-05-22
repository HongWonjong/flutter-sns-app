import 'package:flutter/material.dart';

class SubCommentModal extends StatelessWidget {
  final String parentCommentId;
  final void Function(String text) onSubmit;

  const SubCommentModal({
    Key? key,
    required this.parentCommentId,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 24 + 16, // safeArea 고려
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '대댓글 입력',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '대댓글을 입력하세요',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            minLines: 1,
            maxLines: 5,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  onSubmit(text);
                  Navigator.pop(context);
                }
              },
              child: const Text('등록'),
            ),
          ),
        ],
      ),
    );
  }
}
