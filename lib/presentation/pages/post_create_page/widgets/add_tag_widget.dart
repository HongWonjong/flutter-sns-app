import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/view_models/post_create_view_model.dart';

class AddTagWidget extends StatelessWidget {
  const AddTagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final postVM = ref.read(postCreateViewModel.notifier);
            return TextField(
              decoration: const InputDecoration(
                hintText: '태그를 입력하세요 (예: #감정)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty && !value.contains(' ')) {
                  postVM.addTag(value.startsWith('#') ? value : '#$value');
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
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 30, maxHeight: 30, maxWidth: double.infinity),
          child: Consumer(
            builder: (context, ref, child) {
              final tags = ref.watch(postCreateViewModel).tags;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(tags[index]),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 5),
                itemCount: tags.length,
              );
            },
          ),
        ),
      ],
    );
  }
}