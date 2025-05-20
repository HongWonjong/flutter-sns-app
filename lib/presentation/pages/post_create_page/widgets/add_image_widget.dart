import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/view_models/post_create_view_model.dart';

class AddImageWidget extends StatelessWidget {
  const AddImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final postCreateVM = ref.read(postCreateViewModel.notifier);
        final postState = ref.watch(postCreateViewModel);
        return Column(
          children: [
            postState.image == null
                ? const Icon(Icons.image, size: 100)
                : Image.file(
              File(postState.image!.path),
              height: 200,
              fit: BoxFit.cover,
            ),
            ElevatedButton(
              onPressed: () async {
                await postCreateVM.pickImage();
              },
              child: const Text('이미지 선택'),
            ),
          ],
        );
      },
    );
  }
}