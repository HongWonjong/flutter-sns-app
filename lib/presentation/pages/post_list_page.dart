import 'package:flutter/material.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Hero 위젯 추가
        title: Hero(
          tag: 'appTitleHero',
          child: Material(
            color: Colors.transparent, // 배경 투명하게 해서 텍스트만 애니메이션 됨
            child: const Text(
              '이미지톡',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.deepOrange, // 앱바 색상 취향대로 변경 가능
      ),
      body: const Center(
        child: Text(
          '여기에 게시글 리스트가 표시됩니다.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
