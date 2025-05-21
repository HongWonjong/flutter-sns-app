import 'package:flutter/material.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';
import 'package:flutter_sns_app/presentation/pages/comment_page.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/post_text_overlay.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/icon_button.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final double cardHeight;
  final void Function(String)? onTagTap;

  const PostCard({
    super.key,
    required this.post,
    required this.cardHeight,
    this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
            child: post.imageUrl.isNotEmpty
                ? Image.network(
              post.imageUrl,
              height: cardHeight,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: cardHeight,
                  color: AppStyles.backgroundColor,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: cardHeight,
                  color: AppStyles.backgroundColor,
                  child: const Center(child: Icon(Icons.error)),
                );
              },
            )
                : Container(
              height: cardHeight,
              color: AppStyles.backgroundColor,
              child: const Center(child: Icon(Icons.image)),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Wrap(
              spacing: AppStyles.chipSpacing,
              children: post.tags.map((tag) {
                return GestureDetector(
                  onTap: () {
                    if (onTagTap != null) {
                      onTagTap!(tag);
                    }
                  },
                  child: Chip(
                    label: Text(
                      tag,
                      style: AppStyles.tagStyle,
                    ),
                    backgroundColor: AppStyles.tagBackgroundColor,
                    padding: AppStyles.chipPadding,
                  ),
                );
              }).toList(),
            ),
          ),
          PostTextOverlay(
            text: post.text,
            cardHeight: cardHeight,
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: AppStyles.iconPadding,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: AppStyles.defaultShadow,
              ),
              child: CustomIconButton(
                icon: Icons.comment,
                isLarge: false,
                onPressed: () {
                  if (post.postId.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentPage(postId: post.postId),
                      ),
                    );
                  } else {
                    print('Invalid postId: ${post.postId}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid postId')),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}