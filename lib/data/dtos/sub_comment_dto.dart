import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/domain/entities/sub_comment.dart';

class SubCommentDto {
  final String subCommentId;
  final String commentId;
  final String text;
  final DateTime createdAt;

  SubCommentDto({
    required this.subCommentId,
    required this.commentId,
    required this.text,
    required this.createdAt,
  });

  factory SubCommentDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubCommentDto(
      subCommentId: doc.id,
      commentId: data['commentId'],
      text: data['text'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'commentId': commentId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  SubComment toEntity() => SubComment(
        subCommentId: subCommentId,
        commentId: commentId,
        text: text,
        createdAt: createdAt,
      );

  static SubCommentDto fromEntity(SubComment c) => SubCommentDto(
        subCommentId: c.subCommentId,
        commentId: c.commentId,
        text: c.text,
        createdAt: c.createdAt,
      );
}
