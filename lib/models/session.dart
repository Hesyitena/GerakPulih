import 'dart:convert';

class Session {
  final String id;
  final DateTime date;
  final String exerciseId;
  final String exerciseName;
  final String exerciseIcon;
  final int repsCompleted;
  final int totalReps;
  final int durationSeconds;
  final double score;

  Session({
    required this.id,
    required this.date,
    required this.exerciseId,
    required this.exerciseName,
    required this.exerciseIcon,
    required this.repsCompleted,
    required this.totalReps,
    required this.durationSeconds,
    required this.score,
  });

  String get status => score >= 0.7 ? 'selesai' : 'belum';

  String get formattedDate {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    return '$minutes Menit';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'exerciseIcon': exerciseIcon,
        'repsCompleted': repsCompleted,
        'totalReps': totalReps,
        'durationSeconds': durationSeconds,
        'score': score,
      };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'],
        date: DateTime.parse(json['date']),
        exerciseId: json['exerciseId'],
        exerciseName: json['exerciseName'],
        exerciseIcon: json['exerciseIcon'] ?? 'activity',
        repsCompleted: json['repsCompleted'],
        totalReps: json['totalReps'],
        durationSeconds: json['durationSeconds'],
        score: (json['score'] as num).toDouble(),
      );
}
