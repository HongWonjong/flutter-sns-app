import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  const TagWidget(this.tag, {super.key});
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(tag),
    );
  }
}
