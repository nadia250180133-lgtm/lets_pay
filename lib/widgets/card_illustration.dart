import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// A pure-Flutter, hand-drawn 3D card stack illustration.
/// Mimics the isometric stacked-card artwork from the design reference.
///
/// Structure (back → front):
///   1. [_BackCard2]  – deepest blue, rotated right
///   2. [_BackCard1]  – mid blue, slightly rotated
///   3. [_FrontCard]  – frosted-glass card with $ badge & mini card
class CardIllustration extends StatefulWidget {
  const CardIllustration({super.key});

  @override
  State<CardIllustration> createState() => _CardIllustrationState();
}

class _CardIllustrationState extends State<CardIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Ambient glow / shadow beneath cards ─────────────────────────────
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: _GlowShadow(animation: _controller),
          ),

          // ── Back card 2 (deepest, rotated right) ────────────────────────────
          Positioned(
            bottom: 30,
            right: 0,
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateZ(0.26) // ~15°
                ..translate(0.0, -10.0),
              child: const _BackCard2(),
            ),
          ),

          // ── Back card 1 (mid, rotated slightly) ─────────────────────────────
          Positioned(
            bottom: 30,
            right: 20,
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateZ(0.14) // ~8°
                ..translate(0.0, -5.0),
              child: const _BackCard1(),
            ),
          ),

          // ── Front card (floating animation) ─────────────────────────────────
          Positioned(
            bottom: 20,
            left: 0,
            child: AnimatedBuilder(
              animation: _floatAnim,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: child,
              ),
              child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateZ(-0.07), // ~-4°
                child: const _FrontCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Glow shadow beneath the card stack ─────────────────────────────────────────
class _GlowShadow extends StatelessWidget {
  const _GlowShadow({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final t = animation.value; // 0..1
        return Center(
          child: Container(
            width: 180 + t * 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: RadialGradient(
                colors: [
                  AppColors.accentPrimary.withValues(alpha: 0.35 + t * 0.1),
                  AppColors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Back card 2 ────────────────────────────────────────────────────────────────
class _BackCard2 extends StatelessWidget {
  const _BackCard2();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardBlueDeep, AppColors.cardBlueMid],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.cardBlueDeep.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Align(
          alignment: Alignment.topLeft,
          child: _Chip(),
        ),
      ),
    );
  }
}

// ── Back card 1 ────────────────────────────────────────────────────────────────
class _BackCard1 extends StatelessWidget {
  const _BackCard1();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardBlueBright, AppColors.cardBlueLight],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.cardBlueBright.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Chip(),
            const Spacer(),
            _CardLines(),
          ],
        ),
      ),
    );
  }
}

// ── Front card (glassmorphism) ─────────────────────────────────────────────────
class _FrontCard extends StatelessWidget {
  const _FrontCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 108,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.12),
            const Color(0xFF8CA0FF).withValues(alpha: 0.07),
            AppColors.accentPrimary.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: AppColors.accentPrimary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: dollar badge + mini card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DollarBadge(),
                _MiniCard(),
              ],
            ),
            const Spacer(),
            // Bottom lines
            _FrontCardLines(),
          ],
        ),
      ),
    );
  }
}

// ── Shared sub-widgets ─────────────────────────────────────────────────────────

/// Simulated card chip
class _Chip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.25),
            Colors.white.withValues(alpha: 0.07),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
      ),
    );
  }
}

/// Horizontal line rows for back cards
class _CardLines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Line(width: 70),
        const SizedBox(height: 5),
        _Line(width: 45),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Dollar sign badge on the front card
class _DollarBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentPrimary.withValues(alpha: 0.5),
            AppColors.accentSecondary.withValues(alpha: 0.35),
          ],
        ),
        border: Border.all(
          color: AppColors.accentPrimary.withValues(alpha: 0.55),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPrimary.withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '\$',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

/// Mini card (top-right of front card)
class _MiniCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardBlueLight, AppColors.accentPrimary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardBlueLight.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 14,
              height: 9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white.withValues(alpha: 0.28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  width: 18,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom line group for the front card
class _FrontCardLines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const lineColor = Color(0xFF8CA0FF);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FrontLine(widthFactor: 1.0, color: lineColor),
        const SizedBox(height: 5),
        _FrontLine(widthFactor: 0.72, color: lineColor),
        const SizedBox(height: 5),
        _FrontLine(widthFactor: 0.48, color: lineColor),
      ],
    );
  }
}

class _FrontLine extends StatelessWidget {
  const _FrontLine({required this.widthFactor, required this.color});
  final double widthFactor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Container(
        width: constraints.maxWidth * widthFactor,
        height: 3,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
