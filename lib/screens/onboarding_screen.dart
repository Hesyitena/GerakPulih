import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/services/storage_service.dart';
import 'package:gerakpulih_flutter/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      icon: Icons.monitor_heart_outlined,
      title: 'Selamat Datang di GerakPulih!',
      description: 'Asisten fisioterapi mandiri yang memandu gerakan Anda secara real-time menggunakan kamera ponsel.',
      gradient: [Color(0xFF1DB886), Color(0xFF2DD4A0)],
    ),
    _OnboardingSlide(
      icon: Icons.camera_alt_outlined,
      title: 'Deteksi Pose Real-Time',
      description: 'Teknologi AI kami melacak 33 titik sendi tubuh Anda secara langsung melalui kamera tanpa peralatan tambahan.',
      gradient: [Color(0xFF3D6EDC), Color(0xFF5B8AF0)],
    ),
    _OnboardingSlide(
      icon: Icons.volume_up_outlined,
      title: 'Panduan Suara Santai',
      description: '"Tangannya diangkat sedikit lagi ya." Instruksi ramah seperti pendamping terapis pribadi.',
      gradient: [Color(0xFFE0921F), Color(0xFFF5A623)],
    ),
    _OnboardingSlide(
      icon: Icons.bar_chart_rounded,
      title: 'Pantau Perkembangan Anda',
      description: 'Setiap sesi tersimpan otomatis. Lihat grafik kemajuan dan streak latihan Anda setiap hari.',
      gradient: [Color(0xFF1DB886), Color(0xFF5B8AF0)],
    ),
  ];

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _finish() {
    StorageService.instance.setOnboarded();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Ikon terang karena background slide gelap/berwarna
      ),
      child: Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _slides.length,
              itemBuilder: (_, i) => _buildSlide(_slides[i]),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: 24, right: 24, top: 20,
              bottom: MediaQuery.of(context).padding.bottom + 24,
            ),
            child: Column(
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? AppTheme.primary : Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                // Next button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == _slides.length - 1 ? 'Mulai Sekarang!' : 'Selanjutnya',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentPage == _slides.length - 1 ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                          color: Colors.white, size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _finish,
                  child: const Text('Lewati', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSlide(_OnboardingSlide slide) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: slide.gradient,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(slide.icon, size: 80, color: Colors.white)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(slide.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white,
                      height: 1.2, letterSpacing: -0.3)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(slide.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9), height: 1.6)),
            ),
          ],
        ),
      ),
    );
  }
}
