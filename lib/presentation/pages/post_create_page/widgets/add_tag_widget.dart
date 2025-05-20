import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/view_models/post_create_view_model.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/widgets/tag_widget.dart';

class AddTagWidget extends StatefulWidget {
  const AddTagWidget({super.key});

  @override
  State<AddTagWidget> createState() => _AddTagWidgetState();
}

class _AddTagWidgetState extends State<AddTagWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final postVM = ref.read(postCreateViewModel.notifier);
            return TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '태그를 입력하세요 (예: #감정)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty && !value.contains(' ')) {
                  postVM.addTag(value.startsWith('#') ? value : '#$value');
                  controller.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('유효한 태그를 입력하세요.')),
                  );
                }
              },
            );
          },
        ),
        const SizedBox(height: 5),
        Consumer(
          builder: (context, ref, child) {
            final tags = ref.watch(postCreateViewModel).tags;
            return Container(
              width: double.infinity,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 5,
                runSpacing: 5,
                children: [
                  ...tags.map(
                    (tag) => TagWidget(tag)
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
