import 'package:flutter/material.dart';

/// Animated list item with staggered fade and slight upward motion
/// Use for lists like explore companies, news feed, favorites
class AnimatedListItem extends StatefulWidget {
  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.offset = const Offset(0, 20),
  });

  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset offset;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation with delay based on index
    Future.delayed(widget.delay * widget.index, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Wrapper for lists that need staggered animations
class AnimatedListView extends StatelessWidget {
  const AnimatedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.delay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.offset = const Offset(0, 20),
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset offset;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return AnimatedListItem(
          index: index,
          delay: delay,
          duration: duration,
          curve: curve,
          offset: offset,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}