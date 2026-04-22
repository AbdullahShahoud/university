import 'dart:math';
import 'package:flutter/material.dart';

/// A shake animation widget for error states and validation feedback.
/// Provides a subtle horizontal shake motion to draw attention to errors.
///
/// Features:
/// - Configurable shake intensity and duration
/// - Smooth easeOut curve for natural feel
/// - Automatic trigger on error state
/// - Non-intrusive and premium feel
class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    super.key,
    required this.child,
    this.shake = true,
    this.duration = const Duration(milliseconds: 500),
    this.shakeCount = 3,
    this.shakeOffset = 8.0,
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final bool shake;
  final Duration duration;
  final int shakeCount;
  final double shakeOffset;
  final Curve curve;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.shake) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getShakeOffset(double animationValue) {
    final progress = animationValue * widget.shakeCount * 2 * pi;
    return widget.shakeOffset * (sin(progress) * (1 - animationValue));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_getShakeOffset(_animation.value), 0),
          child: widget.child,
        );
      },
    );
  }
}

/// A smooth toggle animation for switches, checkboxes, and binary states.
/// Provides a premium feel for state changes with subtle scaling and color transitions.
class SmoothToggle extends StatefulWidget {
  const SmoothToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.size = 24.0,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Duration duration;
  final Curve curve;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double size;

  @override
  State<SmoothToggle> createState() => _SmoothToggleState();
}

class _SmoothToggleState extends State<SmoothToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _colorAnimation = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SmoothToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onChanged(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: widget.size * 2,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size / 2),
              color: _colorAnimation.value ?? (widget.value ? theme.primaryColor : theme.disabledColor),
            ),
            child: Align(
              alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: widget.size * 0.8,
                height: widget.size * 0.8,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.thumbColor ?? theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    widget.value ? Icons.check : Icons.close,
                    size: widget.size * 0.4,
                    color: _colorAnimation.value ?? theme.primaryColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A micro-interaction for form validation errors.
/// Combines shake animation with error color transitions.
class ErrorShakeField extends StatefulWidget {
  const ErrorShakeField({
    super.key,
    required this.child,
    this.hasError = false,
    this.errorColor,
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final bool hasError;
  final Color? errorColor;
  final Duration duration;

  @override
  State<ErrorShakeField> createState() => _ErrorShakeFieldState();
}

class _ErrorShakeFieldState extends State<ErrorShakeField>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _colorController;
  late Animation<double> _shakeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeOut,
    ));

    _colorController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: null,
      end: widget.errorColor,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    if (widget.hasError) {
      _shakeController.forward();
      _colorController.forward();
    }
  }

  @override
  void didUpdateWidget(ErrorShakeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _shakeController.forward(from: 0);
      _colorController.forward();
    } else if (!widget.hasError && oldWidget.hasError) {
      _colorController.reverse();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  double _getShakeOffset(double animationValue) {
    const shakeCount = 3;
    const shakeOffset = 6.0;
    final progress = animationValue * shakeCount * 2 * pi;
    return shakeOffset * (sin(progress) * (1 - animationValue));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnimation, _colorAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_getShakeOffset(_shakeAnimation.value), 0),
          child: Container(
            decoration: BoxDecoration(
              border: _colorAnimation.value != null
                  ? Border.all(color: _colorAnimation.value!, width: 1)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// A pulse animation for drawing attention to important elements.
/// Subtle scaling animation that feels premium and non-intrusive.
class PulseWidget extends StatefulWidget {
  const PulseWidget({
    super.key,
    required this.child,
    this.pulse = true,
    this.duration = const Duration(milliseconds: 1000),
    this.scale = 1.05,
    this.curve = Curves.easeInOut,
  });

  final Widget child;
  final bool pulse;
  final Duration duration;
  final double scale;
  final Curve curve;

  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.repeat(reverse: true);

    if (!widget.pulse) {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(PulseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !oldWidget.pulse) {
      _controller.repeat(reverse: true);
    } else if (!widget.pulse && oldWidget.pulse) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}