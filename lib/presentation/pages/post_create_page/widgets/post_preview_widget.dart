import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/utils/image_filters.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/utils/utils.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/widgets/change_text_color_widget.dart';
import 'package:image_picker/image_picker.dart';

class PostPreviewWidget extends StatefulWidget {
  const PostPreviewWidget({
    required this.image,
    required this.text,
    // required this.onPositionChanged,
    required this.onFilterChanged,
    // required this.onTextColorChanged,
    super.key,
  });
  final XFile image;
  final String text;

  // final void Function(Offset) onPositionChanged;
  final void Function(String) onFilterChanged;
  // final void Function(String) onTextColorChanged;

  @override
  State<PostPreviewWidget> createState() => _PostPreviewWidgetState();
}

class _PostPreviewWidgetState extends State<PostPreviewWidget> {
  TextureSource? texture;
  Offset? textPosition;
  GroupShaderConfiguration? currentFilter;
  String textColor = '#000000';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _updateTexture();
  }

  @override
  void didUpdateWidget(PostPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image.path != oldWidget.image.path) {
      _updateTexture();
    }
  }

  void _updateTexture() async {
    texture = await TextureSource.fromFile(File(widget.image.path));
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return texture == null
        ? const Center(child: Text("이미지를 선택해주세요."))
        : Column(
          children: [
            GestureDetector(
              onTapDown: (details) {
                setState(() {
                  textPosition = details.localPosition;
                  // widget.onPositionChanged(details.localPosition);
                });
              },
              child: Stack(
                children: [
                  PipelineImageShaderPreview(
                    texture: texture!,
                    configuration: currentFilter ?? defaultFilter,
                  ),
                  if (widget.text.isNotEmpty)
                    Positioned(
                      left: textPosition != null ? textPosition!.dx : 0,
                      top: textPosition != null ? textPosition!.dy : 0,
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 18,
                          color: colorFromHex(textColor),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Wrap(
              children:
                  filterPresets.entries.map((entry) {
                    final name = entry.key;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentFilter = entry.value;
                            widget.onFilterChanged(entry.key);
                          });
                          print('Selected: $name');
                        },
                        child: Text(name),
                      ),
                    );
                  }).toList(),
            ),
          //   Text('글자 색'),
          //   Wrap(
          //     children: [
          //       ...textColors.map(
          //         (color) => GestureDetector(
          //           onTap: () {},
          //           child: ChangeTextColorWidget(hexString: color),
          //         ),
          //       ),
          //     ],
          //   ),
          ],
        );
  }
}
