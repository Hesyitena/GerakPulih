import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/models/session.dart';
import 'package:gerakpulih_flutter/services/storage_service.dart';
import 'package:gerakpulih_flutter/widgets/glass_card.dart';

class RiwayatTab extends StatefulWidget {
  const RiwayatTab({super.key});

  @override
  State<RiwayatTab> createState() => _RiwayatTabState();
}

class _RiwayatTabState extends State<RiwayatTab> {
  @override
  Widget build(BuildContext context) {
    final sessions = StorageService.instance.getSessions();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Riwayat Latihan',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.dark)),
                  const SizedBox(height: 16),
                  // Weekly bar chart
                  GlassCard(
                    elevated: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Aktivitas Minggu Ini',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                                color: AppTheme.textMuted, letterSpacing: 0.5)),
                        const SizedBox(height: 16),
                        _buildWeeklyBars(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Stats row
                  Row(
                    children: [
                      _statCard('${StorageService.instance.totalSessions}', 'Total Sesi', Icons.fitness_center_rounded),
                      const SizedBox(width: 12),
                      _statCard('${StorageService.instance.currentStreak}', 'Streak Hari', Icons.local_fire_department_rounded),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (sessions.isEmpty) _buildEmpty() else
                    const Text('Semua Sesi',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppTheme.dark)),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
          ),
          if (sessions.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildSessionItem(sessions[i]),
                  ).animate().fadeIn(delay: (i * 60).ms).slideX(begin: 0.1, end: 0),
                  childCount: sessions.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyBars() {
    final days = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
    final sessions = StorageService.instance.getSessions();
    final now = DateTime.now();

    final counts = List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return sessions.where((s) =>
          s.date.year == day.year && s.date.month == day.month && s.date.day == day.day).length;
    });

    final maxCount = counts.reduce((a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (i) {
        final pct = maxCount == 0 ? 0.0 : counts[i] / maxCount;
        final isToday = i == 6;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500 + i * 80),
                  curve: Curves.easeOut,
                  height: 80 * pct + 6,
                  decoration: BoxDecoration(
                    color: pct > 0
                        ? (isToday ? AppTheme.secondary : AppTheme.primary)
                        : Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(days[i],
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w800,
                      color: isToday ? AppTheme.primary : AppTheme.textMuted,
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _statCard(String value, String label, IconData icon) => Expanded(
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: AppTheme.primaryDark, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primaryDark)),
                  Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textMuted)),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildSessionItem(Session s) {
    final isDone = s.status == 'selesai';
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Date column
          Column(
            children: [
              Text('${s.date.day}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.primaryDark)),
              Text(['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'][s.date.month - 1],
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.textMuted)),
            ],
          ),
          Container(width: 1.5, height: 50, margin: const EdgeInsets.symmetric(horizontal: 14),
              color: Colors.black.withOpacity(0.06)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.exerciseName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.dark)),
                const SizedBox(height: 4),
                Text('${s.repsCompleted}/${s.totalReps} rep · ${s.formattedDuration}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDone ? AppTheme.primaryLight : AppTheme.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(isDone ? 'Selesai' : 'Belum',
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w800,
                  color: isDone ? AppTheme.primaryDark : AppTheme.warning,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.history_rounded, size: 72, color: AppTheme.textMuted),
            const SizedBox(height: 16),
            const Text('Belum ada sesi latihan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.dark)),
            const SizedBox(height: 8),
            const Text('Mulai latihan pertamamu sekarang!',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
          ],
        ),
      );
}
