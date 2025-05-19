/// 댓글 Firestore 데이터를 엔티티로 변환한다.
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDto {
  final String commentId;
  final String text;
  final DateTime createdAt;

  CommentDto({
    required this.commentId,
    required this.text,
    required this.createdAt,
  });

  factory CommentDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentDto(
      commentId: doc.id,
      text: data['text'] ?? '',
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'commentId': commentId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}