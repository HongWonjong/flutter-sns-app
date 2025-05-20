import 'package:flutter/material.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
  });

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppStyles.animationDuration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppStyles.animationCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: AppStyles.iconButtonSize,
          height: AppStyles.iconButtonSize,
          decoration: BoxDecoration(
            color: AppStyles.iconBackgroundColor, // 흰색 배경
            shape: BoxShape.circle,
            border: AppStyles.iconBorder, // 검은색 테두리
            boxShadow: AppStyles.defaultShadow, // 그림자
          ),
          child: IconButton(
            icon: Icon(
              widget.icon,
              size: AppStyles.iconSizeLarge,
              color: AppStyles.iconColor,
            ),
            onPressed: widget.onPressed,
            tooltip: widget.tooltip,
            splashRadius: 24.0,
          ),
        ),
      ),
    );
  }
}