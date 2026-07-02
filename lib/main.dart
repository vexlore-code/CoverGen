import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'utils/cover_page_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoverGenApp());
}

class CoverGenApp extends StatelessWidget {
  const CoverGenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CoverPageProvider(),
      child: MaterialApp(
        title: 'CoverGen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF1E3A5F),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              animationDuration: const Duration(milliseconds: 200),
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: _FadeSlideTransition(),
              TargetPlatform.iOS: _FadeSlideTransition(),
              TargetPlatform.macOS: _FadeSlideTransition(),
              TargetPlatform.linux: _FadeSlideTransition(),
              TargetPlatform.windows: _FadeSlideTransition(),
            },
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

/// Gentle fade + subtle slide-up for all screen transitions.
class _FadeSlideTransition extends PageTransitionsBuilder {
  const _FadeSlideTransition();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
