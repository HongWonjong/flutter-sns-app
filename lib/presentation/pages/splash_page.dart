// 앱 시작 시 스플래시 화면 (로딩 후 PostListPage로 이동)
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Page'),
      ),
      body: const Center(
        child: Text('This is the Splash Page'),
      ),
    );
  }
}