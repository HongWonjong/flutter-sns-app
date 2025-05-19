// 게시물 작성, 텍스트 입력, 이미지 업로드 (검사 포함)
import 'package:flutter/material.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Create Page'),
      ),
      body: const Center(
        child: Text('This is the Post Create Page'),
      ),
    );
  }
}