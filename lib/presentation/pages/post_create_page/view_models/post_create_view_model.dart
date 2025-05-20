import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCreateState {
  final String? text;
  final List<String> tags;
  final String? imageUrl;

  PostCreateState({
    this.text,
    List<String>? tags,
    this.imageUrl,
  }) : tags = tags ?? [];

  PostCreateState copyWith({
    String? text,
    List<String>? tags,
    String? imageUrl,
  }) {
    return PostCreateState(
      text: text ?? this.text,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
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
}

final postCreateViewModel =
    NotifierProvider<PostCreateViewModel, PostCreateState>(() {
      return PostCreateViewModel();
    });
