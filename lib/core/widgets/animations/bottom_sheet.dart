import 'package:flutter/material.dart';

/// Custom bottom sheet with slide up animation, draggable, and dimmed background
/// Use for filters, contact options, quick actions
class AppBottomSheet extends StatefulWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.height,
    this.maxHeight,
    this.minHeight,
    this.initialHeight,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(16)),
    this.enableDrag = true,
    this.showHandle = true,
    this.handleColor,
    this.animationDuration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final double? height;
  final double? maxHeight;
  final double? minHeight;
  final double? initialHeight;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final bool enableDrag;
  final bool showHandle;
  final Color? handleColor;
  final Duration animationDuration;
  final Curve curve;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? height,
    double? maxHeight,
    double? minHeight,
    double? initialHeight,
    Color? backgroundColor,
    BorderRadius borderRadius = const BorderRadius.vertical(top: Radius.circular(16)),
    bool enableDrag = true,
    bool showHandle = true,
    Color? handleColor,
    Duration animationDuration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeOut,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      builder: (context) => AppBottomSheet(
        height: height,
        maxHeight: maxHeight,
        minHeight: minHeight,
        initialHeight: initialHeight,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        enableDrag: enableDrag,
        showHandle: showHandle,
        handleColor: handleColor,
        animationDuration: animationDuration,
        curve: curve,
        child: child,
      ),
    );
  }

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  double _currentHeight = 0;
  double _startHeight = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    if (!widget.enableDrag) return;
    _isDragging = true;
    _startHeight = _currentHeight;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!widget.enableDrag || !_isDragging) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final newHeight = _startHeight - details.delta.dy;

    final minHeight = widget.minHeight ?? screenHeight * 0.3;
    final maxHeight = widget.maxHeight ?? screenHeight * 0.9;

    setState(() {
      _currentHeight = newHeight.clamp(minHeight, maxHeight);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (!widget.enableDrag || !_isDragging) return;
    _isDragging = false;

    // Auto-dismiss if dragged down too much
    final screenHeight = MediaQuery.of(context).size.height;
    if (_currentHeight < screenHeight * 0.4) {
      Navigator.of(context).pop();
    } else {
      // Snap back to initial height
      setState(() {
        _currentHeight = widget.initialHeight ?? screenHeight * 0.6;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetHeight = widget.height ??
        widget.initialHeight ??
        (_currentHeight == 0.0 ? screenHeight * 0.6 : _currentHeight);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: _isDragging ? _currentHeight : sheetHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: widget.borderRadius,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.showHandle)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: widget.handleColor ?? Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    Expanded(
                      child: GestureDetector(
                        onVerticalDragStart: _onVerticalDragStart,
                        onVerticalDragUpdate: _onVerticalDragUpdate,
                        onVerticalDragEnd: _onVerticalDragEnd,
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}