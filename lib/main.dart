// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sns_app/data/datasources/storage_datasource.dart';
import 'package:flutter_sns_app/firebase_options.dart';
import 'package:flutter_sns_app/presentation/pages/comment_page.dart';
import 'package:flutter_sns_app/presentation/pages/post_create_page.dart';
import 'package:flutter_sns_app/presentation/pages/post_list_page.dart';
import 'package:flutter_sns_app/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
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
          final postId = ModalRoute.of(context)!.settings.arguments as String;
          return const CommentPage();
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
                Navigator.pushNamed(context, '/comment', arguments: 'temp_post_id');
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