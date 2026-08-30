import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DigaAcaoApp());
}

class DigaAcaoApp extends StatelessWidget {
  const DigaAcaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diga Ação! Podcast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00B4D8),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00B4D8),
          secondary: Color(0xFF00B4D8),
          surface: Color(0xFF1E293B),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
