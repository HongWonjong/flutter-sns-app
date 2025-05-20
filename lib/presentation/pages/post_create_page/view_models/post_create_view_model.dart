import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sns_app/domain/usecases/create_post_usecase.dart';

import '../../../providers/post_provider.dart';

class PostCreateState {
  final String text;
  final List<String> tags;
  final XFile? image;
  final bool isLoading;

  PostCreateState({
    this.text = '',
    this.tags = const [],
    this.image = null,
    this.isLoading = false,
  });

  PostCreateState copyWith({
    String? text,
    List<String>? tags,
    XFile? image,
    bool? isLoading,
  }) {
    return PostCreateState(
      text: text ?? this.text,
      tags: tags ?? this.tags,
      image: image ?? this.image,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PostCreateViewModel extends StateNotifier<PostCreateState> {
  final CreatePostUseCase _createPostUseCase;

  PostCreateViewModel(this._createPostUseCase)
      : super(PostCreateState());

  void setText(String text) {
    state = state.copyWith(text: text);
  }

  void addTag(String tag) {
    if (tag.isNotEmpty && !state.tags.contains(tag)) {
      state = state.copyWith(tags: [...state.tags, tag]);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = state.copyWith(image: pickedFile);
    }
  }

  Future<void> createPost() async {
    if (state.image == null || state.text.isEmpty) {
      throw Exception('이미지와 텍스트는 필수입니다.');
    }

    state = state.copyWith(isLoading: true);
    try {
      final imageFile = File(state.image!.path);
      await _createPostUseCase.execute(
        imageFile: imageFile,
        text: state.text,
        tags: state.tags,
      );
      state = PostCreateState(); // 업로드 후 상태 초기화
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('게시물 업로드 실패: $e');
    }
  }
}

final postCreateViewModel = StateNotifierProvider<PostCreateViewModel, PostCreateState>((ref) {
  final createPostUseCase = ref.watch(createPostUseCaseProvider);
  return PostCreateViewModel(createPostUseCase);
});