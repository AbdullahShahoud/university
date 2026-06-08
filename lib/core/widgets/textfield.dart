import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final TextDirection? textDirection;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final void Function(String)? onChanged;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final Color? fillColor;
  final bool enableMicroFeedback;

  const AppTextField({
    super.key,
    required this.hintText,
    this.validator,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.textDirection,
    this.readOnly = false,
    this.inputFormatters,
    this.autofillHints,
    this.fillColor,
    this.enableMicroFeedback = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hasError = false;
  bool _isFocused = false;

  late FocusNode _focusNode;
  late GlobalKey<FormFieldState> _formFieldKey;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _formFieldKey = GlobalKey<FormFieldState>();

    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller?.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _onTextChange() {
    // Validate on text change to clear error state
    if (_hasError) {
      _formFieldKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShakeAnimation(
      shake: _hasError && widget.enableMicroFeedback,
      child: GlowAnimation(
        isActive: _isFocused && !_hasError && widget.enableMicroFeedback,
        glowColor: Theme.of(context).primaryColor,
        continuous: true,
        child: TextFormField(
          key: _formFieldKey,
          focusNode: _focusNode,
          controller: widget.controller,
          validator: (value) {
            final error = widget.validator?.call(value);
            if (mounted) {
              setState(() => _hasError = error != null);
              if (_hasError && widget.enableMicroFeedback) {
                HapticFeedback.heavyImpact();
              }
            }
            return error;
          },
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          onChanged: (value) {
            // Clear error state on text change if error exists
            if (_hasError) {
              setState(() => _hasError = false);
            }
            widget.onChanged?.call(value);
          },
          style: TextStyle(fontSize: 14.sp),
          textDirection: widget.textDirection,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: widget.fillColor ?? Colors.white,

            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.red, width: 2.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.red, width: 2.w),
            ),
          ),
          readOnly: widget.readOnly,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
        ),
      ),
    );
  }
}

/// ✅ Glow Animation Widget
/// Creates a pulsing glow effect for success states or active fields
///
/// Features:
/// - Smooth pulsing glow effect
/// - Customizable color and intensity
/// - Optional shadow enhancement
/// - Continuous animation or one-time pulse
///
/// Usage:
/// ```dart
/// GlowAnimation(
///   isActive: isSuccess,
///   glowColor: Colors.green,
///   child: YourWidget(),
/// )
/// ```
class GlowAnimation extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final Color glowColor;
  final Duration duration;
  final bool continuous;

  const GlowAnimation({
    super.key,
    required this.child,
    required this.isActive,
    required this.glowColor,
    this.duration = const Duration(milliseconds: 1000),
    this.continuous = false,
  });

  @override
  State<GlowAnimation> createState() => _GlowAnimationState();
}

class _GlowAnimationState extends State<GlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isActive) {
      if (widget.continuous) {
        _controller.repeat(reverse: true);
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void didUpdateWidget(covariant GlowAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      if (widget.continuous) {
        _controller.repeat(reverse: true);
      } else {
        _controller.forward(from: 0.0);
      }
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: widget.glowColor.withValues(
                        alpha: 0.3 * _opacityAnimation.value,
                      ),
                      blurRadius: 12 * _opacityAnimation.value,
                      spreadRadius: 2 * _opacityAnimation.value,
                    ),
                  ]
                : null,
          ),
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}

/// ✅ Shake Animation Widget
/// Creates a horizontal shake effect for error feedback
///
/// Features:
/// - Smooth horizontal shake on error
/// - 400ms duration with multiple oscillations
/// - Configurable intensity
/// - Auto-triggers on error state change
///
/// Usage:
/// ```dart
/// ShakeAnimation(
///   shake: isError,
///   child: YourWidget(),
/// )
/// ```
class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool shake;
  final Duration duration;
  final double distance;

  const ShakeAnimation({
    super.key,
    required this.child,
    required this.shake,
    this.duration = const Duration(milliseconds: 400),
    this.distance = 8.0,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));

    if (widget.shake) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      // Trigger shake when error appears
      _controller.forward(from: 0.0);
    } else if (!widget.shake && oldWidget.shake) {
      // Reset when error clears
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Create oscillating shake effect
        final shake = ((_animation.value * 6) % 2 - 1);
        return Transform.translate(
          offset: Offset(shake * widget.distance, 0),
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}
