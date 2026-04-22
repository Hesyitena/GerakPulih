import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/data/exercises_data.dart';
import 'package:gerakpulih_flutter/models/session.dart';
import 'package:gerakpulih_flutter/services/storage_service.dart';
import 'package:gerakpulih_flutter/screens/camera_screen.dart';
import 'package:gerakpulih_flutter/widgets/glass_card.dart';

class BerandaTab extends StatefulWidget {
  const BerandaTab({super.key});

  @override
  State<BerandaTab> createState() => _BerandaTabState();
}

class _BerandaTabState extends State<BerandaTab> {
  @override
  Widget build(BuildContext context) {
    final storage = StorageService.instance;
    final name = storage.userName;
    final streak = storage.currentStreak;
    final total = storage.totalSessions;
    final sessions = storage.getSessions();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverToBoxAdapter(child: _buildHero(name, streak, total)),
          // Content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildTodayCard(context),
                const SizedBox(height: 20),
                _buildSectionTitle('Program Latihan'),
                const SizedBox(height: 12),
                ...kExercises.take(3).map((ex) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildExerciseRow(context, ex),
                    )),
                if (sessions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildSectionTitle('Sesi Terakhir'),
                  const SizedBox(height: 12),
                  _buildLastSession(sessions.first),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(String name, int streak, int total) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0DC98C), Color(0xFF12E2A3), Color(0xFF5B8AF0)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Halo, ${name.split(' ').first}! 👋',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900,
                            color: Colors.white, height: 1.2)),
                    const SizedBox(height: 4),
                    const Text('Semangat latihan hari ini ya!',
                        style: TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.notifications_outlined, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats
          Row(
            children: [
              _statChip(Icons.local_fire_department_rounded, '$streak Hari', 'Streak'),
              const SizedBox(width: 12),
              _statChip(Icons.check_circle_outline_rounded, '$total Sesi', 'Total'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _statChip(IconData icon, String value, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1)),
                    Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTodayCard(BuildContext context) {
    final todayEx = kExercises.first;
    return GlassCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(99)),
                child: const Text('Target Hari Ini',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.primaryDark)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(todayEx.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.dark)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _miniChip('${todayEx.sets} Set'),
              _miniChip('${todayEx.reps} Repetisi'),
              _miniChip('Sesi 01'),
            ],
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CameraScreen(exercise: todayEx))),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Mulai Latihan Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.3, end: 0, delay: 100.ms, duration: 400.ms);
  }

  Widget _miniChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: AppTheme.bgColor, borderRadius: BorderRadius.circular(99)),
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textSecondary)),
      );

  Widget _buildSectionTitle(String title) => Text(title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppTheme.dark));

  Widget _buildExerciseRow(BuildContext context, ex) => GlassCard(
        padding: const EdgeInsets.all(14),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CameraScreen(exercise: ex))),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: ex.cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(ex.icon, size: 26, color: AppTheme.primaryDark),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ex.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.dark)),
                  Text('${ex.sets} Set · ${ex.reps} Rep · ${ex.difficulty}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
          ],
        ),
      );

  Widget _buildLastSession(Session s) => GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: s.status == 'selesai' ? AppTheme.primaryLight : AppTheme.warning.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                s.status == 'selesai' ? Icons.check_circle_rounded : Icons.pending_rounded,
                color: s.status == 'selesai' ? AppTheme.primaryDark : AppTheme.warning,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.exerciseName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.dark)),
                  Text('${s.repsCompleted}/${s.totalReps} rep · ${s.formattedDuration}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: s.status == 'selesai' ? AppTheme.primaryLight : AppTheme.warning.withOpacity(0.15),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(s.status == 'selesai' ? 'Selesai' : 'Belum',
                  style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w800,
                    color: s.status == 'selesai' ? AppTheme.primaryDark : AppTheme.warning,
                  )),
            ),
          ],
        ),
      );
}
