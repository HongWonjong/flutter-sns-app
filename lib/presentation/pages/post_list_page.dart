// 게시물 목록, 무한 스크롤, 새로고침
import 'package:flutter/material.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post List Page'),
      ),
      body: const Center(
        child: Text('This is the Post List Page'),
      ),
    );
  }
}