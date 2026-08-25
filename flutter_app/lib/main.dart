import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/neumorphic_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/welcome/presentation/welcome_screen.dart';

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

class NeuroTaskApp extends ConsumerWidget {
  const NeuroTaskApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'NeuroTask: Motor de Foco',
      debugShowCheckedModeBanner: false,
      themeMode: themeState.themeMode,
      theme: NeumorphicTheme.lightTheme,
      darkTheme: NeumorphicTheme.darkTheme,
      home: const WelcomeScreen(),
    );
  }
}
