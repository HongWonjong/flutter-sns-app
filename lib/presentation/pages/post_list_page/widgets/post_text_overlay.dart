import 'package:flutter/material.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';

class PostTextOverlay extends StatelessWidget {
  final String text;
  final double cardHeight;

  const PostTextOverlay({
    super.key,
    required this.text,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    // 텍스트 크기를 cardHeight에 비례하여 계산
    final fontSize = (cardHeight * AppStyles.overlayFontSizeRatio).clamp(
      AppStyles.minOverlayFontSize,
      AppStyles.maxOverlayFontSize,
    );

    return Center(
      child: Container(
        height: cardHeight * AppStyles.overlayHeightRatio, // 높이의 80%
        width: MediaQuery.of(context).size.width * AppStyles.overlayWidthRatio, // 너비의 90%
        padding: AppStyles.overlayTextPadding,
        child: Text(
          text,
          style: AppStyles.overlayTextStyle.copyWith(fontSize: fontSize),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}