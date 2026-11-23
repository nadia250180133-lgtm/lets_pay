import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A90D9),
            Color(0xFF7B68EE),
            Color(0xFFB388FF),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -50, left: -50, child: _bubble(150, 0.08)),
          Positioned(top: 100, right: -30, child: _bubble(100, 0.06)),
          Positioned(bottom: 200, left: -40, child: _bubble(120, 0.07)),
          Positioned(bottom: -30, right: -50, child: _bubble(160, 0.05)),
          Positioned(top: 300, left: 50, child: _bubble(60, 0.1)),
          Positioned(bottom: 100, right: 80, child: _bubble(40, 0.12)),
          child,
        ],
      ),
    );
  }

  Widget _bubble(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
