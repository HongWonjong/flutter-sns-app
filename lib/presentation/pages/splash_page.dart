import 'dart:async';
import 'package:flutter/material.dart';
import 'post_list_page/post_list_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  static const String appName = '이미지툭';

  late final List<AnimationController> _letterControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<Offset>> _slideAnimations;

  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();

    _letterControllers = List.generate(
      appName.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300), // ← 각 글자 애니메이션 속도
      ),
    );

    _scaleAnimations = [];
    _slideAnimations = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_animationsInitialized) {
      final size = MediaQuery.of(context).size;
      final screenWidth = size.width;
      final screenHeight = size.height;

      _scaleAnimations = _letterControllers.map((controller) {
        return Tween<double>(begin: 0.6, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.elasticOut,
          ),
        );
      }).toList();

      _slideAnimations = List.generate(appName.length, (index) {
        final startX = -(screenWidth * 0.5 + index * 40);
        final startY = -(screenHeight * 0.5) + index * 30;

        return Tween<Offset>(
          begin: Offset(startX, startY),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _letterControllers[index],
            curve: Curves.bounceOut,
          ),
        );
      });

      _animationsInitialized = true;

      _startAnimations();
    }
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (var controller in _letterControllers) {
      await controller.forward(); // 애니메이션 실행
      await Future.delayed(const Duration(milliseconds: 250));
    }

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PostListPage()),
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _letterControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Align(
            alignment: const Alignment(0, -0.4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '일상을 툭! 툭!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(appName.length, (index) {
                    return AnimatedBuilder(
                      animation: _letterControllers[index],
                      builder: (context, child) {
                        return Transform.translate(
                          offset: _slideAnimations[index].value,
                          child: Transform.scale(
                            scale: _scaleAnimations[index].value,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        appName[index],
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 2.5,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
