// Landmark indices untuk MediaPipe Pose (0-32)
class PoseLandmark {
  static const int nose = 0;
  static const int leftShoulder = 11;
  static const int rightShoulder = 12;
  static const int leftElbow = 13;
  static const int rightElbow = 14;
  static const int leftWrist = 15;
  static const int rightWrist = 16;
  static const int leftHip = 23;
  static const int rightHip = 24;
  static const int leftKnee = 25;
  static const int rightKnee = 26;
  static const int leftAnkle = 27;
  static const int rightAnkle = 28;
}

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String result = '/result';
}

class AppStrings {
  static const String appName = 'GerakPulih';
  static const String appTagline = 'Asisten Fisioterapi Mandiri Pasca-Stroke';
  static const String keyOnboarded = 'is_onboarded';
  static const String keyUserName = 'user_name';
  static const String keyUserAge = 'user_age';
  static const String keySessions = 'sessions_json';
}
