import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/core/firebase_analytics_service.dart';
import 'package:flutter_sns_app/domain/entities/post_settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sns_app/domain/usecases/create_post_usecase.dart';
import 'package:flutter_sns_app/domain/usecases/check_no_person_usecase.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/entities/tag.dart';
import '../../../providers/post_provider.dart';

// class PostSettings {
//   // final double leftPosition;
//   // final double topPosition;
//   final String filterName;

//   const PostSettings({
//     // this.leftPosition = 0,
//     // this.topPosition = 0,
//     this.filterName = 'default',
//   });

//   PostSettings copyWith({
//     // double? leftPosition,
//     // double? topPosition,
//     String? filterName,
//   }) {
//     return PostSettings(
//       // leftPosition: leftPosition ?? this.leftPosition,
//       // topPosition: topPosition ?? this.topPosition,
//       filterName: filterName ?? this.filterName,
//     );
//   }
// }

class PostCreateState {
  final String text;
  final List<Tag> tags;
  final XFile? image;
  final bool isLoading;
  final PostSettings postSettings;

  const PostCreateState({
    this.text = '',
    this.tags = const [],
    this.image,
    this.isLoading = false,
    this.postSettings = const PostSettings(),
  });

  PostCreateState copyWith({
    String? text,
    List<Tag>? tags,
    XFile? image,
    bool? isLoading,
    PostSettings? postSettings,
  }) {
    return PostCreateState(
      text: text ?? this.text,
      tags: tags ?? this.tags,
      image: image ?? this.image,
      isLoading: isLoading ?? this.isLoading,
      postSettings: postSettings ?? this.postSettings,
    );
  }
}

class PostCreateViewModel extends StateNotifier<PostCreateState> {
  final CreatePostUseCase _createPostUseCase;
  final CheckNoPersonUseCase _checkNoPersonUseCase;

  PostCreateViewModel(this._createPostUseCase, this._checkNoPersonUseCase)
      : super(PostCreateState());

  void setText(String text) {
    state = state.copyWith(text: text);
  }

  void addTag(String tag) {
    if (tag.isNotEmpty) {
      state = state.copyWith(
        tags: [...state.tags, Tag(id: Uuid().v4(), text: tag)],
      );
    }
  }

  void removeTag(String tagId) {
    state.tags.removeWhere((tag) => tag.id == tagId);
    state = state.copyWith(tags: state.tags);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final noPerson = await _checkNoPersonUseCase.execute(pickedFile);
      if (noPerson) {
        state = state.copyWith(image: pickedFile);
      } else {
        throw Exception('사람이 포함된 이미지는 저장할 수 없습니다.');
      }
    }
  }

  void onFilterChanged(String filterName) {
    state = state.copyWith(
      postSettings: state.postSettings.copyWith(filterName: filterName)
    );
  }

  // void onPositionChanged(Offset offset) {
  //   state = state.copyWith(
  //     postSettings: state.postSettings.copyWith(
  //       leftPosition: offset.dx,
  //       topPosition: offset.dy,
  //     )
  //   );
  // }

  Future<void> createPost() async {
    if (state.image == null || state.text.isEmpty) {
      throw Exception('이미지와 텍스트는 필수입니다.');
    }

    state = state.copyWith(isLoading: true);
    try {
      final imageFile = File(state.image!.path);
      final post = await _createPostUseCase.execute(
        imageFile: imageFile,
        text: state.text,
        postSettings: state.postSettings,
        tags: state.tags.map((tag) => tag.text).toList(),
      );

      FirebaseAnalyticsService.logPostCreated(
        postId: post.postId,
        textLength: state.text.length,
        hasImage: true,
      );

      state = PostCreateState();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('게시물 업로드 실패: $e');
    }
  }
}

final postCreateViewModel =
StateNotifierProvider<PostCreateViewModel, PostCreateState>((ref) {
  final createPostUseCase = ref.watch(createPostUseCaseProvider);
  final checkNoPersonUseCase = ref.watch(checkNoPersonUseCaseProvider);
  return PostCreateViewModel(createPostUseCase, checkNoPersonUseCase);
});