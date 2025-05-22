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
    final fontSize = (cardHeight * AppStyles.overlayFontSizeRatio).clamp(
      AppStyles.minOverlayFontSize,
      AppStyles.maxOverlayFontSize,
    );

    return IgnorePointer(
      child: Center(
        child: Container(
          height: cardHeight * AppStyles.overlayHeightRatio,
          width: MediaQuery.of(context).size.width * AppStyles.overlayWidthRatio,
          padding: AppStyles.overlayTextPadding,
          child: Text(
            text,
            style: AppStyles.overlayTextStyle.copyWith(fontSize: fontSize),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}