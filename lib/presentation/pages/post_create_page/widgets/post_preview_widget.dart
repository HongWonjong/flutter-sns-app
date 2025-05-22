import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/utils/image_filters.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/view_models/post_create_view_model.dart';

class PostPreviewWidget extends ConsumerStatefulWidget {
  const PostPreviewWidget({super.key});

  @override
  ConsumerState<PostPreviewWidget> createState() => _PostPreviewWidgetState();
}

class _PostPreviewWidgetState extends ConsumerState<PostPreviewWidget> {
  TextureSource? texture;
  String previewText = '';
  Offset? textPosition;
  GroupShaderConfiguration? currentFilter;

  ProviderSubscription<PostCreateState>? _subscriptionImage;
  ProviderSubscription<PostCreateState>? _subscriptionText;

  @override
  void dispose() {
    _subscriptionImage?.close();
    _subscriptionText?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _subscriptionImage ??= ref.listenManual<PostCreateState>(
      postCreateViewModel,
      (previous, next) async {
        final image = next.image;
        if (image != null) {
          final loaded = await TextureSource.fromFile(File(image.path));
          if (mounted) {
            setState(() {
              texture = loaded;
            });
          }
        }
      },
    );

    _subscriptionText ??= ref.listenManual<PostCreateState>(
      postCreateViewModel,
      (previous, next) {
        if (previous != null && previous.text != next.text) {
          final text = next.text;
          if (mounted) {
            setState(() {
              previewText = text;
            });
          }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Post preview Page')),
      body: texture == null ? const Center(child: Text("이미지를 선택해주세요.")) : Column(
        children: [
          GestureDetector(
            onTapDown: (details) {
              setState(() {
                textPosition = details.localPosition;
              });
            },
            child: Stack(
              children: [
                PipelineImageShaderPreview(
                  texture: texture!,
                  configuration: currentFilter ?? defaultFilter,
                ),
                if (previewText.isNotEmpty)
                  Positioned(
                    left: textPosition != null ? textPosition!.dx : 0,
                    top: textPosition != null ? textPosition!.dy : 0,
                    child: Text(
                      previewText,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
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
                        });
                        print('Selected: $name');
                      },
                      child: Text(name),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
