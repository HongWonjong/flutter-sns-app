import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/domain/entities/post.dart';
import 'package:flutter_sns_app/presentation/providers/post_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PostCreateState {
  final String? text;
  final List<String> tags;
  final File? imagefile;
  final Uint8List? imageData;

  PostCreateState({this.text, List<String>? tags, this.imagefile, this.imageData})
    : tags = tags ?? [];

  PostCreateState copyWith({
    String? text,
    List<String>? tags,
    File? imagefile,
    Uint8List? imageData,
  }) {
    return PostCreateState(
      text: text ?? this.text,
      tags: tags ?? this.tags,
      imagefile: imagefile ?? this.imagefile,
      imageData: imageData ?? this.imageData,
    );
  }
}

class PostCreateViewModel extends Notifier<PostCreateState> {
  @override
  build() {
    return PostCreateState();
  }

  void addTag(String tag) {
    state = state.copyWith(tags: [...state.tags, tag]);
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedXfile = await _picker.pickImage(source: ImageSource.gallery);
    final data = await pickedXfile!.readAsBytes();
    state = state.copyWith( imagefile: File(pickedXfile.path), imageData: data);
  }

  void createPost() {
    ref
        .read(createPostUseCaseProvider)
        .execute(
          text: state.text,
          imageFile: state.imagefile,
          tags: state.tags,
        );
  }
}

final postCreateViewModel =
    NotifierProvider<PostCreateViewModel, PostCreateState>(() {
      return PostCreateViewModel();
    });
