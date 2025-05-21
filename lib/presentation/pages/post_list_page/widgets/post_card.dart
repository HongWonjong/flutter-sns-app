import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';
import 'package:flutter_sns_app/presentation/pages/comment_page.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/post_text_overlay.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/widgets/icon_button.dart';
import 'package:flutter_sns_app/presentation/providers/post_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  final double cardHeight;
  final void Function(String)? onTagTap;

  const PostCard({
    super.key,
    required this.post,
    required this.cardHeight,
    this.onTagTap,
  });

  Future<bool> _isPostLiked(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('device_id') ?? '';
    return prefs.getBool('like_${postId}_$deviceId') ?? false;
  }

  Future<void> _toggleLike(BuildContext context, WidgetRef ref, String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('device_id') ?? '';
    final isLiked = await _isPostLiked(postId);

    if (isLiked) {
      await prefs.remove('like_${postId}_$deviceId');
      await ref.read(postProvider.notifier).unlikePost(postId, deviceId);
    } else {
      await prefs.setBool('like_${postId}_$deviceId', true);
      await ref.read(postProvider.notifier).likePost(postId, deviceId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
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
            child: Row(
              children: [
                Container(
                  padding: AppStyles.iconPadding,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: AppStyles.defaultShadow,
                  ),
                  child: FutureBuilder<bool>(
                    future: _isPostLiked(post.postId),
                    builder: (context, snapshot) {
                      final isLiked = snapshot.data ?? false;
                      return CustomIconButton(
                        icon: isLiked ? Icons.favorite : Icons.favorite_border,
                        iconColor: isLiked ? Colors.red : AppStyles.iconColor,
                        isLarge: false,
                        onPressed: () async {
                          if (post.postId.isNotEmpty) {
                            await _toggleLike(context, ref, post.postId);
                          } else {
                            print('Invalid postId: ${post.postId}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid postId')),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
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
                    }, iconColor: null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}