import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/services/storage_service.dart';
import 'package:gerakpulih_flutter/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty) {
      _showError('Nama tidak boleh kosong');
      return;
    }
    if (_ageCtrl.text.trim().isEmpty) {
      _showError('Usia tidak boleh kosong');
      return;
    }
    setState(() => _loading = true);
    await StorageService.instance.saveProfile(
      name: _nameCtrl.text.trim(),
      age: _ageCtrl.text.trim(),
    );
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w700)),
      backgroundColor: AppTheme.danger,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
        children: [
          // Mesh gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8, -0.8),
                radius: 1.4,
                colors: [Color(0xFFD0F5EB), AppTheme.bgColor],
              ),
            ),
          ),
          // Secondary blob
          Positioned(
            bottom: -80, right: -80,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondary.withOpacity(0.12),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  children: [
                    // Top branding
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: AppTheme.shadowPrimary,
                            ),
                            child: const Icon(Icons.monitor_heart_outlined, size: 40, color: Colors.white),
                          ).animate().scale(begin: const Offset(0.7, 0.7), duration: 600.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 12),
                          const Text('GerakPulih',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.dark,
                                  letterSpacing: -0.5)),
                          const SizedBox(height: 4),
                          const Text('Asisten Pemandu Fisioterapi Mandiri\nPasca-Stroke',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary,
                                  height: 1.4)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Glass card form
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.rXl)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.88),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.rXl)),
                            border: const Border(top: BorderSide(color: Colors.white, width: 1.5)),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 32, offset: const Offset(0, -8))],
                          ),
                          padding: EdgeInsets.fromLTRB(24, 32, 24, MediaQuery.of(context).padding.bottom + 24),
                          child: Column(
                            children: [
                              // Greeting
                              Row(
                                children: [
                                  const Text('Selamat Datang', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.dark)),
                                  const SizedBox(width: 8),
                                  const Text('👋', style: TextStyle(fontSize: 22)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Masuk untuk memulai sesi latihan Anda',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                              ),
                              const SizedBox(height: 24),
                              _inputField(label: 'Nama Lengkap', controller: _nameCtrl,
                                  icon: Icons.person_outline, hint: 'Masukkan nama Anda'),
                              const SizedBox(height: 14),
                              _inputField(label: 'Usia', controller: _ageCtrl,
                                  icon: Icons.cake_outlined, hint: 'Contoh: 65', keyboardType: TextInputType.number),
                              const SizedBox(height: 14),
                              _inputField(label: 'PIN (4 digit)', controller: _pinCtrl,
                                  icon: Icons.lock_outline, hint: '••••', obscure: true, keyboardType: TextInputType.number),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity, height: 60,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                                    elevation: 0,
                                    shadowColor: AppTheme.primary.withOpacity(0.4),
                                  ),
                                  child: _loading
                                      ? const SizedBox(width: 24, height: 24,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                      : const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 20),
                                            SizedBox(width: 10),
                                            Text('Mulai Latihan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
                                          ],
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Feature chips
                              Wrap(
                                spacing: 12, runSpacing: 8, alignment: WrapAlignment.center,
                                children: [
                                  _chip(Icons.camera_outlined, 'DETEKSI POSE'),
                                  _chip(Icons.volume_up_outlined, 'PANDUAN SUARA'),
                                  _chip(Icons.bar_chart_rounded, 'RIWAYAT LATIHAN'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOut),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _inputField({
    required String label, required TextEditingController controller,
    required IconData icon, required String hint, bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.darkMedium)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(AppTheme.rLg),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: AppTheme.shadowSm,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(icon, color: AppTheme.textMuted, size: 22),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: hint, hintStyle: const TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                    border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primaryLight,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppTheme.primaryDark),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                color: AppTheme.primaryDark, letterSpacing: 0.5)),
          ],
        ),
      );
}
