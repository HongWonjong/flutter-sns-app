import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  static final FirebaseAnalytics instance = FirebaseAnalytics.instance;

// 댓글 작성시 이벤트 로깅
  static Future<void> logCommentCreated({
  required String postId,
}) async {
  await instance.logEvent(
    name: 'comment_created',
    parameters: {
      'post_id': postId,
    },
  );
}

//게시물 작성시 이벤트 로깅
static Future<void> logPostCreated({
  required String postId,
  required int textLength,
  required bool hasImage,
}) async {
  await instance.logEvent(
    name: 'post_created',
    parameters: {
      'post_id': postId,
      'text_length': textLength,
      'has_image': hasImage,
    },
  );
}


//   static Future<void> logCommentCreated({
//     required String postId,
//     required int commentLength,
//   }) async {
//     await FirebaseAnalytics.instance.logEvent(
//       name: 'comment_created',
//       parameters: {
//         'post_id': postId,
//         'comment_length': commentLength,
// });} 예시
}

// https://firebase.google.com/docs/analytics/events?hl=ko&platform=flutter
// analytics 사용법
// firebase_analytics_service.dart에 함수 정의 -> 필요한 곳에서 호출해서 사용
// 이벤트 이름 & 파라미터 규칙
// name: 소문자, 언더스코어 사용 (snake_case)
// parameters: 최대 25개, 값은 String, int, double, bool, null 허용
// Firebase에서 24~48시간 내 콘솔에서 확인 가능
//