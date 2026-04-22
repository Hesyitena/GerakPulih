import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gerakpulih_flutter/core/constants.dart';
import 'package:gerakpulih_flutter/models/session.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();
  static StorageService get instance => _instance ??= StorageService._();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── ONBOARDING ─────────────────────────────────
  bool get isOnboarded => _prefs?.getBool(AppStrings.keyOnboarded) ?? false;
  Future<void> setOnboarded() => _prefs!.setBool(AppStrings.keyOnboarded, true);

  // ── USER PROFILE ────────────────────────────────
  String get userName => _prefs?.getString(AppStrings.keyUserName) ?? '';
  String get userAge => _prefs?.getString(AppStrings.keyUserAge) ?? '';
  bool get isLoggedIn => userName.isNotEmpty;

  Future<void> saveProfile({required String name, required String age}) async {
    await _prefs!.setString(AppStrings.keyUserName, name);
    await _prefs!.setString(AppStrings.keyUserAge, age);
  }

  Future<void> clearProfile() async {
    await _prefs!.remove(AppStrings.keyUserName);
    await _prefs!.remove(AppStrings.keyUserAge);
  }

  // ── SESSIONS ────────────────────────────────────
  List<Session> getSessions() {
    final raw = _prefs?.getString(AppStrings.keySessions);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => Session.fromJson(e)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveSession(Session session) async {
    final sessions = getSessions();
    sessions.insert(0, session);
    // Keep max 100 sessions
    final trimmed = sessions.take(100).toList();
    await _prefs!.setString(
      AppStrings.keySessions,
      jsonEncode(trimmed.map((s) => s.toJson()).toList()),
    );
  }

  // ── STATS ───────────────────────────────────────
  int get totalSessions => getSessions().length;

  int get currentStreak {
    final sessions = getSessions();
    if (sessions.isEmpty) return 0;
    int streak = 0;
    DateTime? lastDate;
    for (final s in sessions) {
      final d = DateTime(s.date.year, s.date.month, s.date.day);
      if (lastDate == null) {
        lastDate = d;
        streak = 1;
      } else {
        final diff = lastDate.difference(d).inDays;
        if (diff == 1) {
          streak++;
          lastDate = d;
        } else if (diff == 0) {
          continue;
        } else {
          break;
        }
      }
    }
    return streak;
  }
}
