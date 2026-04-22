import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static TtsService? _instance;
  TtsService._();
  static TtsService get instance => _instance ??= TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _enabled = true;
  int _lastSpokeMs = 0;
  static const int _cooldownMs = 7000; // Perbesar cooldown agar tidak terlalu sering bicara

  Future<void> init() async {
    await _tts.setLanguage('id-ID');
    await _tts.setSpeechRate(0.8); // Sedikit lambat untuk lansia
    await _tts.setVolume(0.3);     // Volume lebih pelan lagi agar nyaman
    await _tts.setPitch(1.0);
    // Prefer female voice for friendlier tone
    final voices = await _tts.getVoices;
    if (voices != null) {
      final female = (voices as List).firstWhere(
        (v) => v['locale'] == 'id-ID' && v['name'].toLowerCase().contains('female'),
        orElse: () => null,
      );
      if (female != null) {
        await _tts.setVoice({'name': female['name'], 'locale': 'id-ID'});
      }
    }
  }

  void setEnabled(bool val) => _enabled = val;
  bool get isEnabled => _enabled;

  Future<void> speak(String text) async {
    if (!_enabled) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastSpokeMs < _cooldownMs) return;
    _lastSpokeMs = now;
    await _tts.speak(text);
  }

  // Force speak ignoring cooldown (for milestone announcements)
  Future<void> speakImmediate(String text) async {
    if (!_enabled) return;
    await _tts.stop();
    await _tts.speak(text);
    _lastSpokeMs = DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> stop() async => await _tts.stop();

  void resetCooldown() => _lastSpokeMs = 0;
}
