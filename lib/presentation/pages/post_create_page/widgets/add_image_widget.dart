import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/view_models/post_create_view_model.dart';

class AddImageWidget extends StatefulWidget {
  AddImageWidget({super.key});

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final postCreateVm = ref.read(postCreateViewModel.notifier);
        final post = ref.watch(postCreateViewModel);
        return Column(
          children: [
            post.imageData == null
                ? Icon(Icons.image)
                : Image.memory(post.imageData!),
            ElevatedButton(
              onPressed: () async {
                postCreateVm.pickImage();
              },
              child: Text('이미지 업로드'),
            ),
          ],
        );
      },
    );
  }
}
