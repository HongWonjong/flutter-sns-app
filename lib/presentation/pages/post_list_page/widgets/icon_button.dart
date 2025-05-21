import 'package:flutter/material.dart';
import 'package:flutter_sns_app/presentation/constants/app_styles.dart';

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isLarge;
  final Color? backgroundColor; // 추가: 배경색 속성

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isLarge = true,
    this.backgroundColor,
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.isLarge ? 0.9 : 0.85).animate(
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
    final buttonSize = widget.isLarge ? AppStyles.iconButtonSize : AppStyles.iconButtonSizeSmall;
    final iconSize = widget.isLarge ? AppStyles.iconSizeLarge : AppStyles.iconSizeSmall;
    final iconPadding = widget.isLarge ? AppStyles.iconPadding : AppStyles.iconPaddingSmall;
    final splashRadius = widget.isLarge ? AppStyles.splashRadiusLarge : AppStyles.splashRadiusSmall;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: buttonSize,
          height: buttonSize,
          padding: iconPadding,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppStyles.iconBackgroundColor,
            shape: BoxShape.circle,
            border: AppStyles.iconBorder,
            boxShadow: AppStyles.defaultShadow,
          ),
          child: Center(
            child: IconButton(
              icon: Icon(
                widget.icon,
                size: iconSize,
                color: AppStyles.iconColor,
              ),
              onPressed: widget.onPressed,
              tooltip: widget.tooltip,
              splashRadius: splashRadius,
              constraints: BoxConstraints.tight(Size(buttonSize, buttonSize)),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}