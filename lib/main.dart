import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerakpulih_flutter/core/theme.dart';
import 'package:gerakpulih_flutter/services/storage_service.dart';
import 'package:gerakpulih_flutter/services/tts_service.dart';
import 'package:gerakpulih_flutter/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService.instance.init();
  await TtsService.instance.init();

  // System UI: status bar & nav bar match app background
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,          // Transparan → ikuti background halaman
      statusBarIconBrightness: Brightness.dark,     // Ikon gelap (jam, baterai) di bg terang
      systemNavigationBarColor: AppTheme.bgColor,   // Nav bar bawah sesuai bg app
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const GerakPulihApp());
}

class GerakPulihApp extends StatelessWidget {
  const GerakPulihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GerakPulih',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
