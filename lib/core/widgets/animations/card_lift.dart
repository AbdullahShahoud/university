import 'package:flutter/material.dart';

/// A card widget that provides a premium lift animation on press.
/// Perfect for startup cards, news cards, and any interactive card elements.
///
/// Features:
/// - Slight elevation increase on press
/// - Smooth scale animation (1.0 to 1.02)
/// - Shadow enhancement for depth
/// - Configurable animation duration and curves
/// - Maintains accessibility with proper feedback
class LiftableCard extends StatefulWidget {
  const LiftableCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.elevation = 1,
    this.liftElevation = 4,
    this.scale = 1.02,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeOut,
    this.shadowColor,
    this.backgroundColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double elevation;
  final double liftElevation;
  final double scale;
  final Duration duration;
  final Curve curve;
  final Color? shadowColor;
  final Color? backgroundColor;

  @override
  State<LiftableCard> createState() => _LiftableCardState();
}

class _LiftableCardState extends State<LiftableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.liftElevation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              margin: widget.margin,
              elevation: _elevationAnimation.value,
              shadowColor: widget.shadowColor ?? theme.shadowColor,
              color: widget.backgroundColor ?? theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: widget.borderRadius,
              ),
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A specialized liftable card for startup cards in the explore screen.
/// Includes hover effects and optimized for startup card content.
class StartupLiftableCard extends StatelessWidget {
  const StartupLiftableCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return LiftableCard(
      onTap: onTap,
      onLongPress: onLongPress,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      elevation: 2,
      liftElevation: 8,
      scale: 1.015,
      duration: const Duration(milliseconds: 120),
      child: child,
    );
  }
}

/// A specialized liftable card for news article cards.
/// Optimized for news feed layout with horizontal content.
class NewsLiftableCard extends StatelessWidget {
  const NewsLiftableCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return LiftableCard(
      onTap: onTap,
      onLongPress: onLongPress,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      elevation: 1,
      liftElevation: 6,
      scale: 1.01,
      duration: const Duration(milliseconds: 100),
      child: child,
    );
  }
}