import 'package:flutter/material.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/post_text_overlay.dart';


import 'icon_button.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final double cardHeight;

  const PostCard({
    super.key,
    required this.post,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
            child: post.imageUrl.isNotEmpty
                ? Image.network(
              post.imageUrl,
              height: cardHeight,
              width: double.infinity,
              fit: BoxFit.cover,
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
                return Chip(
                  label: Text(
                    tag,
                    style: AppStyles.tagStyle,
                  ),
                  backgroundColor: AppStyles.tagBackgroundColor,
                  padding: AppStyles.chipPadding,
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/comment', arguments: post.postId);
              },
              child: Container(
                padding: AppStyles.iconPadding,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: AppStyles.defaultShadow,
                ),
                child: CustomIconButton(icon: Icons.comment, isLarge: false),
              ),
            ),
          ),
          PostTextOverlay(
            text: post.text,
            cardHeight: cardHeight,
          ),
        ],
      ),
    );
  }
}