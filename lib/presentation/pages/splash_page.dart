import 'dart:async';
import 'package:flutter/material.dart';
import 'post_list_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // 텍스트 확대/축소 애니메이션 컨트롤러
  late final AnimationController _controller;
  late final Animation<double> _animation;

  // 페이지 전환 시 텍스트 크게 확대되는 애니메이션 컨트롤러
  late final AnimationController _transitionController;
  late final Animation<double> _transitionAnimation;

  @override
  void initState() {
    super.initState();

    // 텍스트가 반복적으로 작아졌다 커지는 애니메이션 설정
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2초 간의 애니메이션
    )..repeat(reverse: true); // 반복 애니메이션 (역방향 포함)

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 전환 애니메이션: 텍스트가 커지면서 페이지 이동
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // 1초 애니메이션
    );

    _transitionAnimation = Tween<double>(begin: 1.0, end: 3.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeOut),
    );

    // 5초 후 애니메이션 중단 + 화면 전환
    Timer(const Duration(seconds: 5), () async {
      _controller.stop(); // 반복 애니메이션 중단
      await _transitionController.forward(); // 텍스트 확대 전환 실행

      if (!mounted) return;

      // PostListPage로 이동 (SplashPage 제거)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PostListPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // GIF 배경 설정
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 서브 타이틀 텍스트
              const Text(
                '일상을 툭! 툭!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 30),
              // 메인 타이틀 애니메이션 (확대/축소 → 전환 시 확대)
              AnimatedBuilder(
                animation: _transitionAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _transitionAnimation.value,
                    child: child,
                  );
                },
                child: ScaleTransition(
                  scale: _animation,
                  child: Hero(
                    tag: 'appTitleHero', // Hero 애니메이션을 위한 태그
                    child: Material(
                      color: Colors.transparent,
                      child: const Text(
                        '이미지톡',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
