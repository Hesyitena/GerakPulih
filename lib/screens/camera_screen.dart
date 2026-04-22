import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/models/exercise.dart';
import 'package:gerakpulih_flutter/models/session.dart';
import 'package:gerakpulih_flutter/services/storage_service.dart';
import 'package:gerakpulih_flutter/services/tts_service.dart';
import 'package:gerakpulih_flutter/widgets/pose_painter.dart';

enum FeedbackStatus { idle, good, warning, bad }

class CameraScreen extends StatefulWidget {
  final Exercise exercise;
  const CameraScreen({super.key, required this.exercise});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraCtrl;
  PoseDetector? _poseDetector;
  bool _isProcessing = false;
  bool _isPaused = false;
  bool _audioEnabled = true;

  int _reps = 0;
  double _angle = 180;
  String _feedbackText = 'Posisikan tubuh Anda di depan kamera';
  FeedbackStatus _feedbackStatus = FeedbackStatus.idle;
  String _repState = 'down'; // 'up' | 'down'

  late DateTime _startTime;
  List<Pose> _poses = [];
  Size? _imageSize;
  int _lastFrameMs = 0;
  static const int _frameThrottleMs = 80; // max ~12fps for ML inference

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first);

    _cameraCtrl = CameraController(front, ResolutionPreset.high, enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420);
    await _cameraCtrl!.initialize();

    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
    );

    if (!mounted) return;
    setState(() {});

    _cameraCtrl!.startImageStream(_processFrame);
  }

  Future<void> _processFrame(CameraImage image) async {
    if (_isProcessing || _isPaused) return;
    // Throttle: skip frames that come too fast to save CPU
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastFrameMs < _frameThrottleMs) return;
    _lastFrameMs = now;
    _isProcessing = true;

    try {
      final inputImage = _buildInputImage(image);
      if (inputImage == null) { _isProcessing = false; return; }

      final poses = await _poseDetector!.processImage(inputImage);

      if (poses.isNotEmpty && mounted) {
        setState(() {
          _poses = poses;
          _imageSize = Size(image.width.toDouble(), image.height.toDouble());
        });
        _analyzePose(poses.first);
      }
    } catch (_) {}

    _isProcessing = false;
  }

  InputImage? _buildInputImage(CameraImage image) {
    final WriteBuffer buffer = WriteBuffer();
    for (final plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }
    final bytes = buffer.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation270deg,
      format: InputImageFormat.yuv_420_888,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  void _analyzePose(Pose pose) {
    final config = widget.exercise.poseConfig;
    final lmA = pose.landmarks[PoseLandmarkType.values[config.jointA]];
    final lmB = pose.landmarks[PoseLandmarkType.values[config.jointB]];
    final lmC = pose.landmarks[PoseLandmarkType.values[config.jointC]];

    if (lmA == null || lmB == null || lmC == null) {
      _updateFeedback(FeedbackStatus.bad, 'Pastikan seluruh tubuh terlihat kamera');
      return;
    }

    if (lmA.likelihood < 0.5 || lmB.likelihood < 0.5 || lmC.likelihood < 0.5) {
      _updateFeedback(FeedbackStatus.bad, 'Posisikan tubuh lebih dekat ke kamera');
      return;
    }

    final angle = _computeAngle(
      Offset(lmA.x, lmA.y),
      Offset(lmB.x, lmB.y),
      Offset(lmC.x, lmC.y),
    );

    if (!mounted) return;
    setState(() => _angle = angle);

    final up = config.upAngle;
    final down = config.downAngle;

    // Feedback
    if (angle > up * 0.9) {
      _updateFeedback(FeedbackStatus.good, 'Posisi sudah benar! Pertahankan.');
      TtsService.instance.speak(widget.exercise.audioPrompts['good']!);
    } else if (angle > (up + down) / 2) {
      _updateFeedback(FeedbackStatus.warning, 'Hampir benar, sedikit lagi!');
    } else {
      _updateFeedback(FeedbackStatus.bad, widget.exercise.audioPrompts['tooLow']!);
      TtsService.instance.speak(widget.exercise.audioPrompts['tooLow']!);
    }

    // Rep counting
    if (angle > up * 0.85 && _repState == 'down') {
      _repState = 'up';
      setState(() => _reps++);
      HapticFeedback.mediumImpact();
      TtsService.instance.speak(widget.exercise.audioPrompts['repDone']!);
      if (_reps >= widget.exercise.reps) {
        TtsService.instance.speakImmediate('Luar biasa! Target ${widget.exercise.reps} repetisi tercapai!');
      }
    }
    if (angle < down * 1.2) {
      _repState = 'down';
    }
  }

  double _computeAngle(Offset a, Offset b, Offset c) {
    final ba = Offset(a.dx - b.dx, a.dy - b.dy);
    final bc = Offset(c.dx - b.dx, c.dy - b.dy);
    final dot = ba.dx * bc.dx + ba.dy * bc.dy;
    final magBA = sqrt(ba.dx * ba.dx + ba.dy * ba.dy);
    final magBC = sqrt(bc.dx * bc.dx + bc.dy * bc.dy);
    if (magBA == 0 || magBC == 0) return 0;
    return acos((dot / (magBA * magBC)).clamp(-1.0, 1.0)) * 180 / pi;
  }

  void _updateFeedback(FeedbackStatus status, String text) {
    if (_feedbackStatus == status && _feedbackText == text) return;
    setState(() { _feedbackStatus = status; _feedbackText = text; });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
    if (_isPaused) {
      TtsService.instance.stop();
      _updateFeedback(FeedbackStatus.idle, 'Latihan dijeda');
    }
  }

  void _toggleAudio() {
    setState(() => _audioEnabled = !_audioEnabled);
    TtsService.instance.setEnabled(_audioEnabled);
  }

  Future<void> _finishSession() async {
    await _cameraCtrl?.stopImageStream();
    await TtsService.instance.stop();
    final duration = DateTime.now().difference(_startTime).inSeconds;
    final score = (_reps / widget.exercise.reps).clamp(0.0, 1.0);
    final session = Session(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      exerciseId: widget.exercise.id,
      exerciseName: widget.exercise.name,
      exerciseIcon: widget.exercise.id,
      repsCompleted: _reps,
      totalReps: widget.exercise.reps,
      durationSeconds: duration,
      score: score,
    );
    await StorageService.instance.saveSession(session);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _cameraCtrl?.dispose();
    _poseDetector?.close();
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera & Pose Layer
          if (_cameraCtrl?.value.isInitialized == true)
            Center(
              child: AspectRatio(
                aspectRatio: 1 / _cameraCtrl!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_cameraCtrl!),
                    if (_poses.isNotEmpty && _imageSize != null && !_isPaused)
                      CustomPaint(
                        painter: PosePainter(
                          _poses,
                          _imageSize!,
                          InputImageRotation.rotation270deg,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          // HUD overlay
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                _buildFeedbackBox(),
                const SizedBox(height: 12),
                _buildRepCounter(),
                const SizedBox(height: 8),
              ],
            ),
          ),
          // Controls at bottom
          Positioned(bottom: 0, left: 0, right: 0, child: _buildControls()),
        ],
      ),
    );
  }

  Widget _buildTopBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: _finishSession,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.close, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(widget.exercise.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildFeedbackBox() {
    final color = switch (_feedbackStatus) {
      FeedbackStatus.good => AppTheme.poseGood,
      FeedbackStatus.warning => AppTheme.poseWarn,
      FeedbackStatus.bad => AppTheme.poseBad,
      FeedbackStatus.idle => Colors.black54,
    };
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(99),
          border: Border.all(color: Colors.white.withOpacity(0.4))),
      child: Text(_feedbackText,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
    );
  }

  Widget _buildRepCounter() => ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text('$_reps / ${widget.exercise.reps}',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900,
                        color: Colors.white, fontFeatures: [FontFeature.tabularFigures()])),
                const Text('REPETISI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                    color: Colors.white60, letterSpacing: 1.5)),
                const SizedBox(height: 4),
                Text('${_angle.toStringAsFixed(0)}°',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white70)),
              ],
            ),
          ),
        ),
      );

  Widget _buildControls() => Container(
        padding: EdgeInsets.only(
          left: 32, right: 32, top: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ctrlBtn(
              icon: Icons.stop_rounded,
              label: 'Stop',
              color: AppTheme.danger.withOpacity(0.3),
              iconColor: AppTheme.danger,
              onTap: _finishSession,
            ),
            // Big pause button
            GestureDetector(
              onTap: _togglePause,
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 20)],
                ),
                child: Icon(_isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    color: Colors.white, size: 36),
              ),
            ),
            _ctrlBtn(
              icon: _audioEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              label: _audioEnabled ? 'Suara' : 'Bisu',
              color: Colors.white.withOpacity(0.15),
              iconColor: Colors.white,
              onTap: _toggleAudio,
            ),
          ],
        ),
      );

  Widget _ctrlBtn({
    required IconData icon, required String label,
    required Color color, required Color iconColor, required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color,
                  border: Border.all(color: Colors.white.withOpacity(0.2))),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
