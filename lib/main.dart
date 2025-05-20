import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/firebase_options.dart';
import 'package:flutter_sns_app/presentation/pages/comment_page.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page/post_create_page.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page/post_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/pages/splash_page.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


void main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://2c3efcc8e9684c23523a2a209f6dbcf6@o4509353960538112.ingest.us.sentry.io/4509353979936768';
      // Adds request headers and IP for users, for more info visit:
      // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
      options.sendDefaultPii = true;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(SentryWidget(child: const ProviderScope(child: MyApp()))),
  );
  // TODO: Remove this line after sending the first sample event to sentry.
  await Sentry.captureException(StateError('This is a sample exception.'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SNS App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/post_create': (context) => const PostCreatePage(),
        '/comment': (context) {
          // postId 제거, comments만 빈 리스트로 넘김
          return const CommentPage(postId: '75e46e13-0986-425c-96a1-e9132eb74ded'); //test용 postId
        },
        '/post_list': (context) => const PostListPage(),
        '/splash': (context) => const SplashPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SNS App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Flutter SNS App'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // postId 제거
                    builder: (context) => const CommentPage(postId: '75e46e13-0986-425c-96a1-e9132eb74ded'), //test용 postId
                  ),
                );
              },
              child: const Text('Go to Comment Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/post_create');
              },
              child: const Text('Go to Post Create Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/post_list');
              },
              child: const Text('Go to Post List Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/splash');
              },
              child: const Text('Go to Splash Page'),
            ),
          ],
        ),
      ),
    );
  }
}
