import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImageWidget extends StatefulWidget {
  AddImageWidget({super.key});

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? imageData;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: () async {
          final pickedXfile =  await _picker.pickImage(source: ImageSource.gallery);
          final data = await pickedXfile!.readAsBytes();
          setState(() {
            imageData = data;
          });
        }, child: Text('이미지 업로드')),
        imageData == null ? Icon(Icons.image) : Image.memory(imageData!),
      ],
    );
  }
}
