/// 게시물 Firestore 데이터를 엔티티로 변환한다.
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDto {
  final String postId;
  final String imageUrl;
  final String text;
  final List<String> tags;
  final DateTime createdAt;

  PostDto({
    required this.postId,
    required this.imageUrl,
    required this.text,
    required this.tags,
    required this.createdAt,
  });

  factory PostDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostDto(
      postId: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      text: data['text'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'imageUrl': imageUrl,
      'text': text,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}