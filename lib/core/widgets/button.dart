import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatefulWidget {
  final String text;
  final Icon? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool onboarding;
  final Color? backgroundColor;
  final Color? textColor;
  final double? paddingV;
  final double? paddingH;
  final double? hight;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.onboarding = false,
    this.backgroundColor,
    this.textColor,
    this.hight,
    this.width,
    this.paddingH,
    this.paddingV,
    this.icon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _animationController.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: widget.isLoading ? null : _onPointerDown,
      onPointerUp: widget.isLoading ? null : _onPointerUp,
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.hight ?? 60.h,

            padding: EdgeInsets.symmetric(
              vertical: widget.paddingV ?? 16.h,
              horizontal: widget.paddingH ?? 16.w,
            ),
            decoration: widget.onboarding
                ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6D4CFF).withValues(alpha: 0.26),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3D5AFE), Color(0xFF8C52FF)],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  )
                : BoxDecoration(
                    color:
                        widget.backgroundColor ??
                        Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6D4CFF).withValues(alpha: 0.26),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.textColor ??
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          widget.icon!,
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          widget.text,
                          style: TextStyle(
                            color:
                                widget.textColor ??
                                Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
