import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/services/storage_service.dart';
import 'package:gerakpulih_flutter/screens/onboarding_screen.dart';
import 'package:gerakpulih_flutter/screens/login_screen.dart';
import 'package:gerakpulih_flutter/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    final storage = StorageService.instance;
    if (!storage.isOnboarded) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    } else if (!storage.isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // ikon gelap di bg terang
      ),
      child: Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [Color(0xFFE8FBF5), AppTheme.bgColor],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: AppTheme.shadowPrimary,
                ),
                child: const Icon(Icons.monitor_heart_outlined, size: 56, color: Colors.white),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08), duration: 1.2.seconds),
              const SizedBox(height: 24),
              const Text('GerakPulih',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppTheme.dark,
                      letterSpacing: -0.5))
                  .animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
              const SizedBox(height: 8),
              const Text('Asisten Fisioterapi Mandiri',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))
                  .animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 60),
              // Progress bar
              Container(
                width: 160,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  )
                      .animate()
                      .custom(
                        duration: 2.seconds,
                        builder: (context, value, child) => LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        ),
                      ),
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
