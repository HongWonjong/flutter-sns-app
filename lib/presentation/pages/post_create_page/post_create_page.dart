import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/view_models/post_create_view_model.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/widgets/add_image_widget.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/widgets/add_tag_widget.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/widgets/post_preview_widget.dart';

class PostCreatePage extends ConsumerWidget {
  const PostCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postCreateViewModel);
    final postCreateVM = ref.read(postCreateViewModel.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(title: const Text('Post Create Page')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 5,
                    maxLength: 200,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '게시물 내용을 입력하세요 (최대 200자)',
                    ),
                    onChanged: (value) {
                      postCreateVM.setText(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  const AddTagWidget(),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      return postState.image == null
                          ? Text('선택된 이미지가 없습니다.')
                          : PostPreviewWidget(
                            image: postState.image!,
                            text: postState.text,
                            // onPositionChanged: postCreateVM.onPositionChanged,
                            onFilterChanged: postCreateVM.onFilterChanged,
                          );
                    },
                  ),
                  const SizedBox(height: 10),
                  AddImageWidget(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        postState.isLoading
                            ? null
                            : () async {
                              try {
                                await postCreateVM.createPost();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('게시물이 업로드되었습니다.'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text('$e')));
                              }
                            },
                    child:
                        postState.isLoading
                            ? const CircularProgressIndicator()
                            : const Text('게시'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
