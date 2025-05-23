import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/utils/image_filters.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class FilteredImage extends StatefulWidget {
  const FilteredImage({
    required this.imageUrl,
    required this.filterName,
    super.key,
  });

  final String imageUrl;
  final String filterName;

  @override
  State<FilteredImage> createState() => _FilteredImageState();
}

class _FilteredImageState extends State<FilteredImage> {
  TextureSource? texture;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImageFromUrl();
  }

  Future<void> _loadImageFromUrl() async {
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final loadedTexture = await TextureSource.fromMemory(bytes);
        setState(() {
          texture = loadedTexture;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load image");
      }
    } catch (e) {
      print('Image load error: $e');
      // 에러 UI 처리 가능
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || texture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return PipelineImageShaderPreview(
      texture: texture!,
      configuration: filterPresets[widget.filterName]!,
    );
  }
}
