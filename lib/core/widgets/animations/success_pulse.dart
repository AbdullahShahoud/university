import 'package:flutter/material.dart';

/// Success animation with checkmark and subtle pulse
/// Use for follow success, save to favorites, message sent
class SuccessPulse extends StatefulWidget {
  const SuccessPulse({
    super.key,
    this.size = 24.0,
    this.color = Colors.green,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
    this.onComplete,
  });

  final double size;
  final Color color;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onComplete;

  @override
  State<SuccessPulse> createState() => _SuccessPulseState();
}

class _SuccessPulseState extends State<SuccessPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 70,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward().then((_) {
      widget.onComplete?.call();
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
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              Icons.check_circle,
              size: widget.size,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}

/// Success feedback widget that can be overlaid on buttons or shown as toast
class SuccessFeedback extends StatelessWidget {
  const SuccessFeedback({
    super.key,
    this.message,
    this.icon = Icons.check_circle,
    this.iconColor = Colors.green,
    this.backgroundColor,
    this.textColor,
    this.duration = const Duration(seconds: 2),
    this.onComplete,
  });

  final String? message;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration duration;
  final VoidCallback? onComplete;

  static void show(
    BuildContext context, {
    String? message,
    IconData icon = Icons.check_circle,
    Color iconColor = Colors.green,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: SuccessFeedback(
            message: message,
            icon: icon,
            iconColor: iconColor,
            backgroundColor: backgroundColor,
            textColor: textColor,
            duration: duration,
            onComplete: () {
              overlayEntry.remove();
              onComplete?.call();
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
        onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SuccessPulse(
            size: 20,
            color: iconColor,
            onComplete: onComplete,
          ),
          if (message != null) ...[
            const SizedBox(width: 8),
            Text(
              message!,
              style: TextStyle(
                color: textColor ?? theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}