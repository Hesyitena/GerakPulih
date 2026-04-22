import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// MediaPipe-style pose overlay painter.
/// Left body = soft red, Right body = cyan, torso = white.
class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;

  PosePainter(this.poses, this.imageSize, this.rotation);

  static final _leftPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round
    ..color = const Color(0xFFFF2D55); // Neon Pink-Red

  static final _leftGlow = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6.0
    ..strokeCap = StrokeCap.round
    ..color = const Color(0xFFFF2D55).withOpacity(0.3)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

  static final _rightPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round
    ..color = const Color(0xFF00FBFF); // Neon Cyan

  static final _rightGlow = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6.0
    ..strokeCap = StrokeCap.round
    ..color = const Color(0xFF00FBFF).withOpacity(0.3)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

  static final _torsoPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..color = Colors.white.withOpacity(0.8);

  static final _dotPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  // MediaPipe body connections
  static const _leftConnections = [
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow],
    [PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist],
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
    [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
    [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],
    [PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel],
    [PoseLandmarkType.leftAnkle, PoseLandmarkType.leftFootIndex],
  ];

  static const _rightConnections = [
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
    [PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
    [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
    [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
    [PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel],
    [PoseLandmarkType.rightAnkle, PoseLandmarkType.rightFootIndex],
  ];

  static const _torsoConnections = [
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],
    [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final pose in poses) {
      // Draw Glow Layers first
      for (final conn in _leftConnections) {
        _drawLine(canvas, pose, conn[0], conn[1], _leftGlow, size);
      }
      for (final conn in _rightConnections) {
        _drawLine(canvas, pose, conn[0], conn[1], _rightGlow, size);
      }

      // Draw Main Layers
      for (final conn in _leftConnections) {
        _drawLine(canvas, pose, conn[0], conn[1], _leftPaint, size);
      }
      for (final conn in _rightConnections) {
        _drawLine(canvas, pose, conn[0], conn[1], _rightPaint, size);
      }
      for (final conn in _torsoConnections) {
        _drawLine(canvas, pose, conn[0], conn[1], _torsoPaint, size);
      }

      // Dots on limb landmarks
      pose.landmarks.forEach((type, lm) {
        if (type.index < 11 || lm.likelihood < 0.5) return;
        final pos = _translate(lm.x, lm.y, size);
        
        // Dot Glow
        canvas.drawCircle(pos, 6, Paint()..color = (type.index % 2 == 0 ? _leftPaint.color : _rightPaint.color).withOpacity(0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
        canvas.drawCircle(pos, 3, _dotPaint);
      });
    }
  }

  void _drawLine(Canvas canvas, Pose pose, PoseLandmarkType t1, PoseLandmarkType t2, Paint paint, Size size) {
    final lm1 = pose.landmarks[t1];
    final lm2 = pose.landmarks[t2];
    if (lm1 == null || lm2 == null) return;
    if (lm1.likelihood < 0.5 || lm2.likelihood < 0.5) return;
    canvas.drawLine(_translate(lm1.x, lm1.y, size), _translate(lm2.x, lm2.y, size), paint);
  }

  /// Coordinate translation for Android front camera with rotation270deg.
  ///
  /// The raw camera buffer is LANDSCAPE (e.g. 1920×1080):
  ///   imageSize.width  = 1920 (longer side)
  ///   imageSize.height = 1080 (shorter side)
  ///
  /// ML Kit with rotation270 returns:
  ///   lm.x → ranges over imageSize.HEIGHT → maps to screen WIDTH
  ///   lm.y → ranges over imageSize.WIDTH  → maps to screen HEIGHT
  ///
  /// The Flutter camera package auto-mirrors the front camera preview,
  /// but ML Kit returns raw (unmirrored) coordinates. So we flip X to match.
  Offset _translate(double x, double y, Size screenSize) {
    final scaledX = x / imageSize.height * screenSize.width;
    final scaledY = y / imageSize.width  * screenSize.height;
    // Flip X to match the auto-mirrored front camera preview
    return Offset(screenSize.width - scaledX, scaledY);
  }

  @override
  bool shouldRepaint(covariant PosePainter old) => old.poses != poses;
}
