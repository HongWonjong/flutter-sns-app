import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/widgets/post_preview_widget.dart';
import '../view_models/post_create_view_model.dart';


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
            // postState.image == null
            //     ? const Icon(Icons.image, size: 100)
            //     : Image.file(
            //   File(postState.image!.path),
            //   height: 200,
            //   fit: BoxFit.cover,
            // ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await postCreateVM.pickImage(); // 반환값 사용하지 않음
                  if (postState.image != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이미지가 성공적으로 선택되었습니다.')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                  );
                }
              },
              child: const Text('이미지 선택'),
            ),
          ],
        );
      },
    );
  }
}