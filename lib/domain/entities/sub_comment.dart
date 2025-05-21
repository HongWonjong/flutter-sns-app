class SubComment {
  final String commentId; // 대댓글의 상위 댓글 ID
  final String subCommentId; // Firestore 문서 ID, UUID로 생성
  final String text; // 댓글 내용
  final DateTime createdAt; // 작성 시간, ISO 8601 형식

  SubComment({
    required this.subCommentId,
    required this.commentId,
    required this.text,
    required this.createdAt,
  });
}