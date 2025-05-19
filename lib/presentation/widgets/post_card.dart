/// 게시물&댓글 표시 위젯
import 'package:flutter/material.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';

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
    final imageHeight = cardHeight * AppStyles.imageHeightRatio;
    final textAreaHeight = cardHeight * AppStyles.textAreaHeightRatio;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppStyles.cardBackgroundColor,
        borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppStyles.cardBorderRadius),
                  topRight: Radius.circular(AppStyles.cardBorderRadius),
                ),
                child: post.imageUrl.isNotEmpty
                    ? Image.network(
                  post.imageUrl,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: imageHeight,
                      color: AppStyles.backgroundColor,
                      child: const Center(child: Icon(Icons.error)),
                    );
                  },
                )
                    : Container(
                  height: imageHeight,
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
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppStyles.defaultShadow,
                    ),
                    child: Icon(
                      Icons.comment,
                      size: AppStyles.iconSizeSmall,
                      color: AppStyles.iconColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: AppStyles.contentPadding,
            child: SizedBox(
              height: textAreaHeight - 40, // 삼각형 아이콘 공간 제외
              child: Text(
                post.text,
                style: AppStyles.bodyStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: Icon(
                Icons.arrow_drop_down,
                size: AppStyles.iconSizeLarge,
                color: AppStyles.iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}