import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_card.dart';

/// Pantalla de Configuración de NeuroTask (Modo Oscuro, Sonido, Notificaciones e Info).
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _anchorNotifications = true;
  bool _autoBrownNoise = false;
  bool _hapticFeedback = true;

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      backgroundColor: context.surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: context.textMainColor),
          onPressed: () {
            HapticHelper.lightTap();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Configuración',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.textMainColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección Apariencia
            _buildSectionHeader(context, 'Apariencia & Tema'),
            NeumorphicCard(
              padding: const EdgeInsets.all(8),
              borderRadius: 20,
              child: SwitchListTile(
                secondary: Icon(
                  themeState.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: AppColors.primaryIndigo,
                ),
                title: Text(
                  'Modo Oscuro',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.textMainColor,
                  ),
                ),
                subtitle: Text(
                  'Soft Slate para reducir la fatiga visual',
                  style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
                ),
                value: themeState.isDarkMode,
                activeColor: AppColors.primaryIndigo,
                onChanged: (val) {
                  themeNotifier.toggleTheme();
                },
              ),
            ),

            const SizedBox(height: 24),

            // Sección Foco & Notificaciones
            _buildSectionHeader(context, 'Anclas & Notificaciones'),
            NeumorphicCard(
              padding: const EdgeInsets.all(8),
              borderRadius: 20,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.anchor_rounded, color: AppColors.brandGlowCyan),
                    title: Text(
                      'Alertas de Anclas Horarias',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.textMainColor,
                      ),
                    ),
                    subtitle: Text(
                      'Recordar clases, reuniones o compromisos fijos',
                      style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
                    ),
                    value: _anchorNotifications,
                    activeColor: AppColors.brandGlowCyan,
                    onChanged: (val) {
                      HapticHelper.lightTap();
                      setState(() => _anchorNotifications = val);
                    },
                  ),
                  Divider(height: 1, color: context.textMutedColor.withOpacity(0.15)),
                  SwitchListTile(
                    secondary: const Icon(Icons.waves_rounded, color: AppColors.primaryIndigo),
                    title: Text(
                      'Ruido Marrón Automático',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.textMainColor,
                      ),
                    ),
                    subtitle: Text(
                      'Iniciar sonido ambiente al arrancar la sesión de foco',
                      style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
                    ),
                    value: _autoBrownNoise,
                    activeColor: AppColors.primaryIndigo,
                    onChanged: (val) {
                      HapticHelper.lightTap();
                      setState(() => _autoBrownNoise = val);
                    },
                  ),
                  Divider(height: 1, color: context.textMutedColor.withOpacity(0.15)),
                  SwitchListTile(
                    secondary: const Icon(Icons.vibration_rounded, color: AppColors.amberWarning),
                    title: Text(
                      'Vibración Háptica',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.textMainColor,
                      ),
                    ),
                    subtitle: Text(
                      'Retroalimentación táctil al arrastrar o completar tareas',
                      style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
                    ),
                    value: _hapticFeedback,
                    activeColor: AppColors.amberWarning,
                    onChanged: (val) {
                      HapticHelper.lightTap();
                      setState(() => _hapticFeedback = val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sección Información de la App
            _buildSectionHeader(context, 'Acerca de NeuroTask'),
            NeumorphicCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Versión del prototipo',
                        style: TextStyle(color: context.textMainColor, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '1.0.0-beta01',
                        style: TextStyle(color: context.textSecondaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Motor de ordenamiento',
                        style: TextStyle(color: context.textMainColor, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'DAG Topological Sort',
                        style: TextStyle(color: AppColors.primaryIndigo, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: context.textSecondaryColor,
        ),
      ),
    );
  }
}
