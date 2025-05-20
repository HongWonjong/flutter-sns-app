import 'package:flutter/material.dart';

class AppStyles {
  // 색상
  static const Color backgroundColor = Colors.grey;
  static const Color cardBackgroundColor = Color(0xFFE0E0E0);
  static const Color tagBackgroundColor = Colors.black54;
  static const Color tagTextColor = Colors.white;
  static const Color iconColor = Colors.black;
  static const Color shadowColor = Colors.black26;
  static const Color accentColor = Colors.black;
  static const Color dividerColor = Colors.black;
  static const Color iconBackgroundColor = Colors.white;
  static const Color overlayBackgroundColor = Colors.transparent;

  // 크기
  static const double cardBorderRadius = 12.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeLarge = 48.0;
  static const double chipPaddingHorizontal = 4.0;
  static const double chipSpacing = 8.0;
  static const double dividerThickness = 1.0;
  static const double iconButtonSize = 64.0;
  static const double overlayHeightRatio = 0.8; // 텍스트 오버레이 높이 비율
  static const double overlayWidthRatio = 0.9; // 텍스트 오버레이 너비 비율
  static const double overlayFontSizeRatio = 0.1; // 텍스트 크기 비율 (cardHeight 기준)
  static const double minOverlayFontSize = 24.0; // 최소 텍스트 크기
  static const double maxOverlayFontSize = 48.0; // 최대 텍스트 크기

  // 패딩
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const EdgeInsets contentPadding = EdgeInsets.all(12.0);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: chipPaddingHorizontal);
  static const EdgeInsets iconPadding = EdgeInsets.all(4.0);
  static const EdgeInsets overlayTextPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);

  // 텍스트 스타일
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
  );
  static const TextStyle tagStyle = TextStyle(
    color: tagTextColor,
    fontSize: 12,
  );
  static const TextStyle overlayTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        color: Colors.black87,
        blurRadius: 8.0, // 강화된 그림자
        offset: Offset(2, 2),
      ),
      Shadow(
        color: Colors.black87,
        blurRadius: 8.0,
        offset: Offset(-2, -2),
      ),
    ],
  );

  // 그림자
  static const List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 8.0,
      offset: Offset(2, 2),
      spreadRadius: 1.0,
    ),
  ];

  // 테두리
  static const Border iconBorder = Border(
    top: BorderSide(color: dividerColor, width: 1.5),
    bottom: BorderSide(color: dividerColor, width: 1.5),
    left: BorderSide(color: dividerColor, width: 1.5),
    right: BorderSide(color: dividerColor, width: 1.5),
  );

  // 애니메이션
  static const Duration animationDuration = Duration(milliseconds: 200);
  static const Curve animationCurve = Curves.easeInOut;
}