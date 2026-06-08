import 'dart:ui';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        /// base color
        Container(color: Theme.of(context).scaffoldBackgroundColor),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1380EC),
                Color(0xCC1380EC),
                Color(0x991380EC),
                Color(0x661380EC),
                Color(0x331380EC),
                Color.fromARGB(13, 25, 135, 245),
              ],
              stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
            ),
          ),
        ),

        /// screen content
        child,
      ],
    );
  }
}

class BlurCircle extends StatelessWidget {
  final double widt;
  final double high;
  final Color color;

  const BlurCircle({
    super.key,
    required this.widt,
    required this.high,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // sigma reduced from 130 → 60: still produces a soft ambient glow
    // but ~4.7× cheaper (blur cost ∝ sigma²). Combined with the
    // RepaintBoundary on each circle, the GPU work is done only once.
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: widt,
        height: high,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
