import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/view_models/post_create_view_model.dart';

import '../../../../domain/entities/tag.dart';

class TagWidget extends StatelessWidget {
  const TagWidget(this.tag, {super.key});
  final Tag tag;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tag.text),
          Consumer(
            builder: (context, ref, child) {
              return GestureDetector(onTap: (){
                ref.read(postCreateViewModel.notifier).removeTag(tag.id);
              }, child: Icon(size: 20, Icons.delete));
            }
          )
        ],
      ),
    );
  }
}
