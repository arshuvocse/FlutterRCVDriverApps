import 'package:flutter/material.dart';

/// Shared gradient backdrop used across splash and onboarding screens.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F1C94), Color(0xFF006ADC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const Positioned(
          left: -120,
          top: -140,
          child: _GlowCircle(
            size: 280,
            color: Color(0x0Fffffff),
          ),
        ),
        const Positioned(
          right: -100,
          bottom: -120,
          child: _GlowCircle(
            size: 260,
            color: Color(0x0Cffffff),
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.35,
            spreadRadius: size * 0.14,
            offset: Offset.zero,
          ),
        ],
      ),
    );
  }
}
