import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/services/storage_service.dart';
import 'package:gerakpulih_flutter/services/tts_service.dart';
import 'package:gerakpulih_flutter/screens/login_screen.dart';
import 'package:gerakpulih_flutter/widgets/glass_card.dart';

class SetelanTab extends StatefulWidget {
  const SetelanTab({super.key});

  @override
  State<SetelanTab> createState() => _SetelanTabState();
}

class _SetelanTabState extends State<SetelanTab> {
  bool _audioEnabled = true;
  bool _notifEnabled = true;

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.logout_rounded, color: AppTheme.danger, size: 32),
              ),
              const SizedBox(height: 20),
              const Text('Keluar dari Akun?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.dark)),
              const SizedBox(height: 8),
              const Text('Data latihan Anda akan tetap tersimpan di perangkat ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, height: 1.5)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: Colors.black.withOpacity(0.1)),
                      ),
                      child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await StorageService.instance.clearProfile();
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (_) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.danger,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = StorageService.instance.userName;
    final age = StorageService.instance.userAge;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // ─── Premium Profile Header ───────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Stack(
                children: [
                  // Background gradient blob
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.primary.withOpacity(0.12),
                            AppTheme.bgColor.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    child: Column(
                      children: [
                        // Avatar with gradient ring
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.primary, AppTheme.secondary],
                            ),
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.35),
                                blurRadius: 24, offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Container(
                            width: 84, height: 84,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: const Icon(Icons.person_rounded, color: AppTheme.primary, size: 48),
                          ),
                        ).animate().scale(begin: const Offset(0.7, 0.7), duration: 500.ms, curve: Curves.elasticOut),
                        const SizedBox(height: 16),
                        Text(name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.dark))
                            .animate().fadeIn(delay: 100.ms),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text('$age Tahun  •  Pasca Stroke',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.primaryDark)),
                        ).animate().fadeIn(delay: 150.ms),
                        const SizedBox(height: 24),
                        // Stats row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _statCard('${StorageService.instance.totalSessions}', 'Sesi', Icons.check_circle_outline_rounded, AppTheme.primary),
                            const SizedBox(width: 12),
                            _statCard('${StorageService.instance.currentStreak}', 'Hari Streak', Icons.local_fire_department_rounded, AppTheme.warning),
                          ],
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Settings Body ────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Section: Pengaturan
                _sectionHeader('Pengaturan', Icons.tune_rounded),
                const SizedBox(height: 10),
                _settingsCard([
                  _settingToggle(
                    icon: Icons.volume_up_rounded,
                    iconColor: AppTheme.primary,
                    title: 'Suara Pemandu',
                    subtitle: 'Umpan balik audio saat latihan',
                    value: _audioEnabled,
                    onChanged: (v) {
                      setState(() => _audioEnabled = v);
                      TtsService.instance.setEnabled(v);
                    },
                  ),
                  _settingToggle(
                    icon: Icons.notifications_active_rounded,
                    iconColor: AppTheme.warning,
                    title: 'Notifikasi Harian',
                    subtitle: 'Pengingat untuk tetap berlatih',
                    value: _notifEnabled,
                    onChanged: (v) => setState(() => _notifEnabled = v),
                  ),
                ]),

                const SizedBox(height: 20),

                // Section: Informasi
                _sectionHeader('Informasi', Icons.info_outline_rounded),
                const SizedBox(height: 10),
                _settingsCard([
                  _infoTile(Icons.shield_outlined, AppTheme.secondary, 'Kebijakan Privasi', trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted)),
                  _infoTile(Icons.help_center_outlined, const Color(0xFF4FACFE), 'Pusat Bantuan', trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted)),
                  _infoTile(Icons.verified_outlined, AppTheme.success, 'Versi Aplikasi',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Text('v1.0.0', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.primaryDark)),
                      )),
                ]),

                const SizedBox(height: 28),

                // Logout button
                GestureDetector(
                  onTap: _logout,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.danger.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.danger.withOpacity(0.2)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: AppTheme.danger, size: 20),
                        SizedBox(width: 10),
                        Text('Keluar dari Akun',
                            style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w900, fontSize: 15)),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String val, String label, IconData icon, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(val, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textMuted)),
          ],
        ),
      );

  Widget _sectionHeader(String title, IconData icon) => Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.textMuted),
          const SizedBox(width: 6),
          Text(title.toUpperCase(),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.textMuted, letterSpacing: 1.2)),
        ],
      );

  Widget _settingsCard(List<Widget> children) => GlassCard(
        padding: EdgeInsets.zero,
        elevated: true,
        child: Column(
          children: List.generate(children.length, (i) => Column(
            children: [
              children[i],
              if (i < children.length - 1)
                Divider(height: 1, indent: 20, endIndent: 20, color: Colors.black.withOpacity(0.05)),
            ],
          )),
        ),
      );

  Widget _settingToggle({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconColor, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.dark)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
                ],
              ),
            ),
            Switch.adaptive(value: value, onChanged: onChanged, activeColor: AppTheme.primary),
          ],
        ),
      );

  Widget _infoTile(IconData icon, Color iconColor, String title, {required Widget trailing}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconColor, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.dark)),
            ),
            trailing,
          ],
        ),
      );
}
