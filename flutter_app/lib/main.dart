import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/neumorphic_theme.dart';
import 'features/brain_dump/presentation/brain_dump_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: NeuroTaskApp(),
    ),
  );
}

class NeuroTaskApp extends StatelessWidget {
  const NeuroTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroTask: Motor de Foco',
      debugShowCheckedModeBanner: false,
      theme: NeumorphicTheme.lightTheme,
      home: const BrainDumpScreen(),
    );
  }
}
