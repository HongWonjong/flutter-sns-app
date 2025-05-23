// lib/data/dtos/post_dto.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sns_app/data/dtos/post_settings_dto.dart';

class PostDto {
  final String postId;
  final String imageUrl;
  final String text;
  final List<String> tags;
  final DateTime createdAt;
  final PostSettingsDto postSettingsDto;

  PostDto({
    required this.postId,
    required this.imageUrl,
    required this.text,
    required this.tags,
    required this.createdAt,
    required this.postSettingsDto,
  });

  factory PostDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    String createdAtString = data['createdAt'] ?? DateTime.now().toUtc().toIso8601String();
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(createdAtString).toLocal(); // UTC → KST 변환
      print('파싱된 createdAt (KST): $createdAt');
    } catch (e) {
      print('createdAt 파싱 실패: $e, 기본값 사용');
      createdAt = DateTime.now().toLocal();
    }
    return PostDto(
      postId: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      text: data['text'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      postSettingsDto: data['postSettings'] != null ? PostSettingsDto.fromJson(data['postSettings']) : PostSettingsDto(),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    final createdAtString = createdAt.toUtc().toIso8601String();
    print('Firestore에 저장될 createdAt (UTC): $createdAtString');
    return {
      'postId': postId,
      'imageUrl': imageUrl,
      'text': text,
      'tags': tags,
      'postSettings': postSettingsDto.toJson(),
      'createdAt': createdAtString,
    };
  }
}