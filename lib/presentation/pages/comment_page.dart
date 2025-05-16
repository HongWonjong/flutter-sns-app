// 댓글 목록, 댓글 작성, 페이지 이동
import 'package:flutter/material.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment Page'),
      ),
      body: const Center(
        child: Text('This is the Comment Page'),
      ),
    );
  }
}