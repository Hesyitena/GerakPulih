import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/data/exercises_data.dart';
import 'package:gerakpulih_flutter/models/exercise.dart';
import 'package:gerakpulih_flutter/screens/camera_screen.dart';
import 'package:gerakpulih_flutter/widgets/exercise_card.dart';
import 'package:gerakpulih_flutter/widgets/glass_card.dart';

class LatihanTab extends StatefulWidget {
  const LatihanTab({super.key});

  @override
  State<LatihanTab> createState() => _LatihanTabState();
}

class _LatihanTabState extends State<LatihanTab> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  List<Exercise> get _filtered => kExercises.where((e) {
        final matchCat = _selectedCategory == 'Semua' || e.category == _selectedCategory;
        final matchSearch = _searchQuery.isEmpty ||
            e.name.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchCat && matchSearch;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Program Latihan',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.dark)),
                  const SizedBox(height: 4),
                  const Text('Pilih latihan yang sesuai kondisi Anda',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                  const SizedBox(height: 16),
                  // Search
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    blur: 20,
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppTheme.textMuted),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _searchQuery = v),
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                            decoration: const InputDecoration(
                              hintText: 'Cari latihan...',
                              hintStyle: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Category chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: kCategories.map((cat) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _categoryChip(cat),
                          )).toList(),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
          ),
          // Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) => ExerciseCard(
                  exercise: _filtered[i],
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CameraScreen(exercise: _filtered[i]))),
                ).animate().fadeIn(delay: (i * 80).ms).slideY(begin: 0.3, end: 0),
                childCount: _filtered.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label) {
    final isActive = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: isActive ? AppTheme.primary : Colors.white.withOpacity(0.6)),
          boxShadow: isActive ? AppTheme.shadowPrimary : AppTheme.shadowSm,
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w800,
              color: isActive ? Colors.white : AppTheme.textSecondary,
            )),
      ),
    );
  }
}
