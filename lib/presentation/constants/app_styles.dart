import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static const Color backgroundColor = Colors.grey;
  static const Color cardBackgroundColor = Color(0xFFE0E0E0);
  static const Color tagBackgroundColor = Color(0xFFFFFFFF);
  static const Color tagTextColor = Colors.black;
  static const Color iconColor = Colors.black;
  static const Color shadowColor = Colors.black26;
  static const Color accentColor = Colors.black;
  static const Color dividerColor = Colors.black;
  static const Color iconBackgroundColor = Colors.white;
  static const Color overlayBackgroundColor = Colors.transparent;
  static const Color searchActiveBackgroundColor = Colors.blue;
  static const Color dividerGradientStart = Color(0xFFBBBBBB);
  static const Color dividerGradientEnd = Color(0xFF888888);
  static const Color listBackgroundGradientStart = Color(0xFFF5F5F5);
  static const Color listBackgroundGradientEnd = Color(0xFFE0E0E0);

  static const double cardBorderRadius = 12.0;
  static const double iconSizeSmall = 24.0;
  static const double iconSizeLarge = 40.0;
  static const double chipPaddingHorizontal = 4.0;
  static const double chipSpacing = 8.0;
  static const double dividerThickness = 0.5;
  static const double iconButtonSize = 64.0;
  static const double iconButtonSizeSmall = 48.0;
  static const double overlayHeightRatio = 0.8;
  static const double overlayWidthRatio = 0.9;
  static const double overlayFontSizeRatio = 0.1;
  static const double minOverlayFontSize = 24.0;
  static const double maxOverlayFontSize = 48.0;
  static const double splashRadiusLarge = 20.0;
  static const double splashRadiusSmall = 16.0;
  static const double cardSpacing = 8.0;

  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const EdgeInsets contentPadding = EdgeInsets.all(12.0);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: chipPaddingHorizontal);
  static const EdgeInsets iconPadding = EdgeInsets.all(2.0);
  static const EdgeInsets iconPaddingSmall = EdgeInsets.all(2.0);
  static const EdgeInsets overlayTextPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);

  static final TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle bodyStyle = TextStyle(
    fontSize: 16,
  );
  static final TextStyle tagStyle = GoogleFonts.sunflower(
    color: tagTextColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle overlayTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: Colors.black87,
        blurRadius: 8.0,
        offset: Offset(2, 2),
      ),
      Shadow(
        color: Colors.black87,
        blurRadius: 8.0,
        offset: Offset(-2, -2),
      ),
    ],
  );
  static final TextStyle likeCommentCountStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: Colors.black87,
        blurRadius: 4.0,
        offset: Offset(1, 1),
      ),
      Shadow(
        color: Colors.black87,
        blurRadius: 4.0,
        offset: Offset(-1, -1),
      ),
    ],
  );

  static const List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 8.0,
      offset: Offset(2, 2),
      spreadRadius: 1.0,
    ),
  ];

  static const List<BoxShadow> dividerShadow = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 2.0,
      offset: Offset(0, 1),
      spreadRadius: 0.5,
    ),
  ];

  static const Border iconBorder = Border(
    top: BorderSide(color: dividerColor, width: 1.5),
    bottom: BorderSide(color: dividerColor, width: 1.5),
    left: BorderSide(color: dividerColor, width: 1.5),
    right: BorderSide(color: dividerColor, width: 1.5),
  );

  static const Duration animationDuration = Duration(milliseconds: 200);
  static const Curve animationCurve = Curves.easeInOut;
  static const Duration cardAnimationDuration = Duration(milliseconds: 300);
}