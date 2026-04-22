import 'package:flutter/material.dart';

/// A wrapper widget that provides smooth fade transitions for content visibility changes.
/// Perfect for toggling sensitive information, expandable sections, or any content that
/// appears/disappears with a premium, subtle animation.
///
/// Features:
/// - Fade in/out transitions
/// - Configurable duration (default: 200ms)
/// - EaseInOut curve for smooth feel
/// - Maintains layout stability during transitions
class AnimatedVisibilityWrapper extends StatelessWidget {
  const AnimatedVisibilityWrapper({
    super.key,
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  });

  final bool visible;
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: visible
          ? child
          : const SizedBox.shrink(key: ValueKey('invisible')),
    );
  }
}

/// A specialized version for toggle switches and binary states.
/// Provides a more pronounced transition for clear state changes.
class AnimatedToggleWrapper extends StatelessWidget {
  const AnimatedToggleWrapper({
    super.key,
    required this.isOn,
    required this.onChild,
    required this.offChild,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
  });

  final bool isOn;
  final Widget onChild;
  final Widget offChild;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: isOn
          ? onChild
          : offChild,
    );
  }
}