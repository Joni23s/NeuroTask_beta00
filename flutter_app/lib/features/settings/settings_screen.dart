import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neumorphic_card.dart';
import 'settings_controller.dart';

/// Pantalla de Configuración de NeuroTask (Modo Oscuro, Sonido, Notificaciones e Info).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

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
                  themeState.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
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
                  style: TextStyle(
                      fontSize: 12, color: context.textSecondaryColor),
                ),
                value: themeState.isDarkMode,
                activeThumbColor: AppColors.primaryIndigo,
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
                    secondary: const Icon(Icons.anchor_rounded,
                        color: AppColors.brandGlowCyan),
                    title: Text(
                      'Alertas de Anclas Horarias',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.textMainColor,
                      ),
                    ),
                    subtitle: Text(
                      'Recordar clases, reuniones o compromisos fijos',
                      style: TextStyle(
                          fontSize: 12, color: context.textSecondaryColor),
                    ),
                    value: settingsState.anchorNotifications,
                    activeThumbColor: AppColors.brandGlowCyan,
                    onChanged: (val) =>
                        settingsNotifier.toggleAnchorNotifications(val),
                  ),
                  Divider(
                      height: 1,
                      color: context.textMutedColor.withValues(alpha: 0.15)),
                  SwitchListTile(
                    secondary: const Icon(Icons.waves_rounded,
                        color: AppColors.primaryIndigo),
                    title: Text(
                      'Ruido Marrón Automático',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.textMainColor,
                      ),
                    ),
                    subtitle: Text(
                      'Iniciar sonido ambiente al arrancar la sesión de foco',
                      style: TextStyle(
                          fontSize: 12, color: context.textSecondaryColor),
                    ),
                    value: settingsState.autoBrownNoise,
                    activeThumbColor: AppColors.primaryIndigo,
                    onChanged: (val) =>
                        settingsNotifier.toggleAutoBrownNoise(val),
                  ),
                  Divider(
                      height: 1,
                      color: context.textMutedColor.withValues(alpha: 0.15)),
                  SwitchListTile(
                    secondary: const Icon(Icons.vibration_rounded,
                        color: AppColors.amberWarning),
                    title: Text(
                      'Vibración Háptica',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.textMainColor,
                      ),
                    ),
                    subtitle: Text(
                      'Retroalimentación táctil al arrastrar o completar tareas',
                      style: TextStyle(
                          fontSize: 12, color: context.textSecondaryColor),
                    ),
                    value: settingsState.hapticFeedback,
                    activeThumbColor: AppColors.amberWarning,
                    onChanged: (val) =>
                        settingsNotifier.toggleHapticFeedback(val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sección Motor de Descompresión Cognitiva
            _buildSectionHeader(context, 'Motor de Descompresión Cognitiva'),
            NeumorphicCard(
              padding: const EdgeInsets.all(8),
              borderRadius: 20,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.auto_awesome_rounded,
                        color: AppColors.brandGlowCyan),
                    title: Text(
                      'Descompresión Híbrida con IA (Gemini)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.textMainColor,
                      ),
                    ),
                    subtitle: Text(
                      settingsState.hasGeminiApiKey
                          ? 'Usa Gemini con respaldo automático del motor NLP local'
                          : 'Modo NLP Local activo; configurá una clave para activar IA',
                      style: TextStyle(
                          fontSize: 12, color: context.textSecondaryColor),
                    ),
                    value: settingsState.useAiDecompression,
                    activeThumbColor: AppColors.brandGlowCyan,
                    onChanged: (val) =>
                        settingsNotifier.toggleUseAiDecompression(val),
                  ),
                  Divider(
                      height: 1,
                      color: context.textMutedColor.withValues(alpha: 0.15)),
                  ListTile(
                    leading: const Icon(Icons.key_rounded,
                        color: AppColors.primaryIndigo),
                    title: Text(
                      'Clave de API de Google Gemini (Opcional)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.textMainColor,
                      ),
                    ),
                    subtitle: Text(
                      settingsState.hasGeminiApiKey
                          ? 'Configurada (${_maskApiKey(settingsState.geminiApiKey)}) · Tocá para editar'
                          : 'Opcional: sin clave funciona el Motor NLP Heurístico + Micro-Tasking Offline',
                      style: TextStyle(
                          fontSize: 12, color: context.textSecondaryColor),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded,
                        color: context.textSecondaryColor),
                    onTap: () {
                      HapticHelper.lightTap();
                      showDialog<void>(
                        context: context,
                        builder: (_) => _GeminiApiKeyDialog(
                          initialKey: settingsState.geminiApiKey,
                          onSave: settingsNotifier.setGeminiApiKey,
                        ),
                      );
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
                        'Versión de la app',
                        style: TextStyle(
                            color: context.textMainColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '1.0.0',
                        style: TextStyle(
                            color: context.textSecondaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Motor de ordenamiento',
                        style: TextStyle(
                            color: context.textMainColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        settingsState.isAiActive
                            ? 'Híbrido IA + Kahn DAG'
                            : 'NLP Heurístico + Kahn DAG',
                        style: const TextStyle(
                            color: AppColors.primaryIndigo,
                            fontWeight: FontWeight.bold),
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

  static String _maskApiKey(String key) {
    final trimmed = key.trim();
    if (trimmed.length <= 8) return '••••';
    return '${trimmed.substring(0, 4)}••••${trimmed.substring(trimmed.length - 4)}';
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

class _GeminiApiKeyDialog extends StatefulWidget {
  final String initialKey;
  final Future<void> Function(String) onSave;

  const _GeminiApiKeyDialog({
    required this.initialKey,
    required this.onSave,
  });

  @override
  State<_GeminiApiKeyDialog> createState() => _GeminiApiKeyDialogState();
}

class _GeminiApiKeyDialogState extends State<_GeminiApiKeyDialog> {
  late final TextEditingController _controller;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.cardSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'API Key de Google Gemini',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: context.textMainColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Opcional: conectá tu clave para descompresión semántica con Gemini 2.5 Flash. Sin clave funciona 100% el Motor NLP Local.',
            style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            obscureText: _obscure,
            style: TextStyle(fontSize: 13, color: context.textMainColor),
            decoration: InputDecoration(
              hintText: 'AIza...',
              filled: true,
              fillColor: context.pressedSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: context.textSecondaryColor,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (widget.initialKey.trim().isNotEmpty)
          TextButton(
            onPressed: () async {
              await widget.onSave('');
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              'Borrar clave',
              style: TextStyle(color: AppColors.amberWarning),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: TextStyle(color: context.textSecondaryColor),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryIndigo,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
            await widget.onSave(_controller.text);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
