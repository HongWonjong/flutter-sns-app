import 'package:flutter/material.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/utils/utils.dart';

class ChangeTextColorWidget extends StatelessWidget {
  const ChangeTextColorWidget({required this.hexString, super.key});
  final String hexString;
  @override
  Widget build(BuildContext context) {
    return Container(width: 50, height: 50, color: colorFromHex(hexString));
  }
}
