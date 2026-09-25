import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/neumorphic_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/achievements/achievements_vault_screen.dart';
import 'features/anchors/anchors_manager_screen.dart';
import 'features/auth/login_register_screen.dart';
import 'features/brain_dump/brain_dump_screen.dart';
import 'features/focus/single_task_screen.dart';
import 'features/focus/summary_celebration_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/splash/splash_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth': (context) => const LoginRegisterScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/brain-dump': (context) => const BrainDumpScreen(),
        '/single-task': (context) => const SingleTaskScreen(),
        '/celebration': (context) => const SummaryCelebrationScreen(),
        '/anchors': (context) => const AnchorsManagerScreen(),
        '/achievements': (context) => const AchievementsVaultScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
