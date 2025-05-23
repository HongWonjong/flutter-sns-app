import 'dart:ui';

Color colorFromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 7) buffer.write('ff'); // alpha 없으면 기본값
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

List<String> textColors = [
  '#FFFF0000',
  '#FF0000FF',
  '#FFFFFFFF',
  '#FF000000',
  '#FF4CAF50',
  '#FF9800',
];