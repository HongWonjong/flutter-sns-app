import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/firebase_options.dart';
import 'package:flutter_sns_app/presentation/pages/comment_page.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/post_create_page.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/post_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'presentation/pages/splash_page.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 디바이스 ID 초기화
  final prefs = await SharedPreferences.getInstance();
  String deviceId = prefs.getString('device_id') ?? const Uuid().v4();
  await prefs.setString('device_id', deviceId); // ID 저장

  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://2c3efcc8e9684c23523a2a209f6dbcf6@o4509353960538112.ingest.us.sentry.io/4509353979936768';
      options.sendDefaultPii = true;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(SentryWidget(child: ProviderScope(child: MyApp(deviceId: deviceId)))),
  );
}

class MyApp extends StatelessWidget {
  final String deviceId;

  const MyApp({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SNS App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        '/post_create': (context) => const PostCreatePage(),
        '/comment': (context) => const CommentPage(postId: '75e46e13-0986-425c-96a1-e9132eb74ded'),
        '/post_list': (context) => const PostListPage(),
      },
    );
  }
}