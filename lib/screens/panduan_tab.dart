import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/widgets/glass_card.dart';

class PanduanTab extends StatelessWidget {
  const PanduanTab({super.key});

  static const _guides = [
    _GuideItem(
      title: 'Cara Menggunakan Aplikasi',
      subtitle: 'Mulai latihan dalam 3 langkah mudah',
      icon: Icons.phone_android_rounded,
      color: Color(0xFF4FACFE),
      steps: [
        'Pilih program latihan yang sesuai di tab Latihan.',
        'Posisikan diri Anda di depan kamera agar seluruh tubuh terlihat.',
        'Ikuti instruksi audio & gerakan kerangka di layar. Sistem akan menghitung repetisi otomatis.',
      ],
    ),
    _GuideItem(
      title: 'Persiapan Sebelum Latihan',
      subtitle: 'Pastikan kondisi aman sebelum memulai',
      icon: Icons.accessibility_new_rounded,
      color: Color(0xFF12E2A3),
      steps: [
        'Gunakan pakaian yang longgar dan nyaman.',
        'Siapkan ruangan dengan pencahayaan cukup agar kamera dapat mendeteksi gerakan.',
        'Lakukan pemanasan ringan (5 menit) sebelum memulai sesi.',
        'Pastikan ada orang di dekat Anda saat pertama kali berlatih.',
      ],
    ),
    _GuideItem(
      title: 'Tips Keamanan',
      subtitle: 'Keselamatan adalah prioritas utama',
      icon: Icons.health_and_safety_rounded,
      color: Color(0xFFFFB75E),
      steps: [
        'Hentikan latihan segera jika terasa nyeri atau pusing.',
        'Jangan memaksakan gerakan melebihi kemampuan Anda saat ini.',
        'Selalu ada pegangan atau kursi di dekat Anda untuk keseimbangan.',
        'Minum air yang cukup sebelum dan sesudah latihan.',
      ],
    ),
    _GuideItem(
      title: 'Pemulihan Pasca Stroke',
      subtitle: 'Pahami perjalanan pemulihan Anda',
      icon: Icons.favorite_rounded,
      color: Color(0xFFFF5E62),
      steps: [
        'Konsistensi adalah kunci — latihan rutin setiap hari lebih baik dari latihan berat sesekali.',
        'Catat perkembangan Anda di tab Riwayat untuk memantau kemajuan.',
        'Selalu konsultasikan program latihan ini dengan dokter atau fisioterapis Anda.',
        'Rayakan setiap pencapaian kecil — setiap repetisi adalah langkah menuju pemulihan!',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // ─── Header ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: AppTheme.shadowPrimary,
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Panduan',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.dark)),
                          Text('Pelajari cara latihan yang benar',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  // ─── Warning Banner ──────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.warning.withOpacity(0.15), AppTheme.warning.withOpacity(0.05)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppTheme.warning.withOpacity(0.35)),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(
                            color: AppTheme.warning.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(Icons.medical_services_rounded, color: AppTheme.warning, size: 22),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Konsultasikan dengan Dokter',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.dark)),
                              SizedBox(height: 2),
                              Text('Selalu dapatkan persetujuan dokter sebelum memulai program ini.',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: 0.15, end: 0, duration: 400.ms).fadeIn(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ─── Guide Cards ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _GuideCard(guide: _guides[i], index: i),
                childCount: _guides.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Guide Data Model ──────────────────────────────────────────────────────────
class _GuideItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> steps;
  const _GuideItem({
    required this.title, required this.subtitle,
    required this.icon, required this.color, required this.steps,
  });
}

// ─── Expandable Guide Card ─────────────────────────────────────────────────────
class _GuideCard extends StatefulWidget {
  final _GuideItem guide;
  final int index;
  const _GuideCard({required this.guide, required this.index});

  @override
  State<_GuideCard> createState() => _GuideCardState();
}

class _GuideCardState extends State<_GuideCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.guide;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        padding: EdgeInsets.zero,
        elevated: true,
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Column(
            children: [
              // Card Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: g.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(g.icon, color: g.color, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g.title,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.dark)),
                          const SizedBox(height: 2),
                          Text(g.subtitle,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          color: _expanded ? g.color : AppTheme.textMuted, size: 24),
                    ),
                  ],
                ),
              ),

              // Expanded steps
              if (_expanded) ...[
                Divider(height: 1, color: g.color.withOpacity(0.15)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    children: List.generate(g.steps.length, (i) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24, height: 24,
                                margin: const EdgeInsets.only(top: 1),
                                decoration: BoxDecoration(
                                  color: g.color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text('${i + 1}',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(g.steps[i],
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w600,
                                        color: AppTheme.textSecondary, height: 1.5)),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ).animate().fadeIn(delay: (widget.index * 80).ms).slideY(begin: 0.15, end: 0),
    );
  }
}
