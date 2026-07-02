import 'package:flutter/material.dart';
import 'template_select_screen.dart';
import '../widgets/covergen_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _tagFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));

    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );
    _tagFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    );

    _ctrl.forward();

    // Navigate after splash completes
    Future.delayed(const Duration(milliseconds: 2600), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const TemplateSelectScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1628),
              Color(0xFF1E3A5F),
              Color(0xFF0D2440),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Subtle background circles
            Positioned(
              top: -60,
              right: -60,
              child: _GlowCircle(size: 220, color: const Color(0xFF2A5298).withValues(alpha: 0.3)),
            ),
            Positioned(
              bottom: -80,
              left: -40,
              child: _GlowCircle(size: 180, color: const Color(0xFF1E3A5F).withValues(alpha: 0.4)),
            ),
            Positioned(
              bottom: 100,
              right: 30,
              child: _GlowCircle(size: 80, color: Colors.amber.withValues(alpha: 0.15)),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, child) => FadeTransition(
                      opacity: _fade,
                      child: ScaleTransition(scale: _scale, child: child),
                    ),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A90D9).withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(18),
                      child: const CoverGenLogo(size: 74, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App name
                  FadeTransition(
                    opacity: _fade,
                    child: const Text(
                      'CoverGen',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  FadeTransition(
                    opacity: _tagFade,
                    child: Text(
                      'Your Academic Cover, Crafted Perfectly',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading dot
                  FadeTransition(
                    opacity: _tagFade,
                    child: _PulsingDot(),
                  ),
                ],
              ),
            ),
            // Developer credit — bottom of screen
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _tagFade,
                child: Column(
                  children: [
                    Text(
                      'Developed by',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.35),
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Md. Jubayer Hasan Munna',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.65),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      );
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final delay = i * 0.33;
            final t = ((_ctrl.value + delay) % 1.0);
            final scale = 0.5 + 0.5 * (t < 0.5 ? t * 2 : (1 - t) * 2);
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3 + 0.7 * scale),
              ),
            );
          },
        );
      }),
    );
  }
}
