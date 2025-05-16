class Post {
  final String postId; // Firestore 문서 ID, UUID로 생성
  final String imageUrl; // Firebase Storage에 저장된 이미지 URL
  final String text; // 게시물 내용, 최대 200자
  final List<String> tags; // 게시물 분류용 해시태그 리스트
  final DateTime createdAt; // 작성 시간, ISO 8601 형식

  Post({
    required this.postId,
    required this.imageUrl,
    required this.text,
    required this.tags,
    required this.createdAt,
  });
}