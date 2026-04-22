import 'package:flutter/material.dart';
import 'package:gerakpulih_flutter/core/constants.dart';

class PoseConfig {
  final int jointA;
  final int jointB; // vertex (elbow/knee)
  final int jointC;
  final double upAngle;   // arm fully raised / leg fully extended
  final double downAngle; // arm lowered / leg bent

  const PoseConfig({
    required this.jointA,
    required this.jointB,
    required this.jointC,
    required this.upAngle,
    required this.downAngle,
  });
}

class Exercise {
  final String id;
  final String name;
  final String category;
  final IconData icon;
  final int sets;
  final int reps;
  final String description;
  final String bodyPart;
  final String difficulty;
  final Map<String, String> audioPrompts;
  final PoseConfig poseConfig;
  final Color cardColor;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.sets,
    required this.reps,
    required this.description,
    required this.bodyPart,
    required this.difficulty,
    required this.audioPrompts,
    required this.poseConfig,
    required this.cardColor,
  });
}
