import 'package:flutter/material.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';

class EndOfPostsMessage extends StatelessWidget {
  const EndOfPostsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.pagePadding,
      child: Center(
        child: Text(
          '게시물은 여기까지입니다.',
          style: AppStyles.bodyStyle.copyWith(
            fontSize: 24,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}