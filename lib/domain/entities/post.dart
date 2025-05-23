import 'package:flutter_sns_app/domain/entities/post_settings.dart';

class Post {
  final String postId; // Firestore 문서 ID, UUID로 생성
  final String imageUrl; // Firebase Storage에 저장된 이미지 URL
  final String text; // 게시물 내용, 최대 200자
  final List<String> tags; // 게시물 분류용 해시태그 리스트
  final DateTime createdAt; // 작성 시간, ISO 8601 형식
  final List<String> likes; // 좋아요한 디바이스 ID 리스트
  final PostSettings postSettings;

  Post({
    required this.postId,
    required this.imageUrl,
    required this.text,
    required this.tags,
    required this.createdAt,
    required this.likes,
    required this.postSettings,
  });

  Post copyWith({
    String? postId,
    String? imageUrl,
    String? text,
    List<String>? tags,
    DateTime? createdAt,
    List<String>? likes,
    PostSettings? postSettings,
  }) {
    return Post(
      postId: postId ?? this.postId,
      imageUrl: imageUrl ?? this.imageUrl,
      text: text ?? this.text,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      postSettings: postSettings ?? this.postSettings,
    );
  }
}