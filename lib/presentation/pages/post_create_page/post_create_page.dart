// 게시물 작성, 텍스트 입력, 이미지 업로드 (검사 포함)
import 'package:flutter/material.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/widgets/add_image_widget.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/widgets/add_tag_widget.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Create Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children : [
            TextField(
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
            AddTagWidget(),
            AddImageWidget(),
          ],
        ),
      ),
    );
  }
}