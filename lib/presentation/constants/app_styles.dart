// lib/presentation/constants/app_styles.dart
import 'package:flutter/material.dart';

class AppStyles {
  // 색상
  static const Color backgroundColor = Colors.grey;
  static const Color cardBackgroundColor = Color(0xFFE0E0E0); // 회색 박스
  static const Color tagBackgroundColor = Colors.black54;
  static const Color tagTextColor = Colors.white;
  static const Color iconColor = Colors.grey;
  static const Color shadowColor = Colors.black26;
  static const Color accentColor = Colors.blue;

  // 크기
  static const double cardBorderRadius = 12.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeLarge = 30.0;
  static const double chipPaddingHorizontal = 4.0;
  static const double chipSpacing = 8.0;
  static const double imageHeightRatio = 0.6; // 이미지 높이 비율 (카드 높이의 60%)
  static const double textAreaHeightRatio = 0.4; // 텍스트 영역 비율

  // 패딩
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const EdgeInsets contentPadding = EdgeInsets.all(12.0);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: chipPaddingHorizontal);
  static const EdgeInsets iconPadding = EdgeInsets.all(4.0);

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

  // 그림자
  static const List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 4,
      offset: Offset(2, 2),
    ),
  ];
}