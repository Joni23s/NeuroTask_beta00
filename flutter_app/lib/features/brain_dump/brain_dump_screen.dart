import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_context.dart';
import '../../core/utils/haptic_helper.dart';
import '../../core/widgets/neuro_badge.dart';
import '../../core/widgets/neuro_inset_container.dart';
import '../../core/widgets/neuro_modal_sheet.dart';
import '../../core/widgets/neumorphic_button.dart';
import '../../core/widgets/theme_toggle_button.dart';
import '../achievements/achievements_controller.dart';
import '../focus/focus_controller.dart';
import '../focus/single_task_screen.dart';
import 'brain_dump_controller.dart';
import 'voice_dictation_sheet.dart';

class BrainDumpScreen extends ConsumerStatefulWidget {
  const BrainDumpScreen({super.key});

  @override
  ConsumerState<BrainDumpScreen> createState() => _BrainDumpScreenState();
}

class _BrainDumpScreenState extends ConsumerState<BrainDumpScreen> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  bool _showEmptyHint = false;
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onProcessAndSequence() async {
    final rawText = _textController.text.trim();

    // Empathetic Validation: If completely empty, softly guide the user
    if (rawText.isEmpty) {
      HapticHelper.warning();
      setState(() {
        _showEmptyHint = true;
      });
      _focusNode.requestFocus();
      return;
    }

    setState(() {
      _showEmptyHint = false;
    });

    HapticHelper.lightTap();
    ref.read(brainDumpProvider.notifier).setProcessing(true);
    ref.read(achievementsProvider.notifier).recordBrainDump();

    // Show peaceful breathing processing modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: context.cardSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.primaryIndigo),
                const SizedBox(height: 24),
                Text(
                  'Construyendo Grafo Lógico...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textMain),
                ),
                const SizedBox(height: 8),
                Text(
                  'Eliminando ruido cognitivo y aislando tu primer paso...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: context.textSecondary),
                ),
              ],
            ),
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;

    ref.read(focusProvider.notifier).loadFromRawText(rawText);
    ref.read(brainDumpProvider.notifier).setProcessing(false);

    Navigator.pop(context); // Close dialog
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SingleTaskScreen()),
    );
  }

  void _loadPreset(String presetKey) {
    HapticHelper.lightTap();
    setState(() {
      _showEmptyHint = false;
    });
    ref.read(brainDumpProvider.notifier).loadPreset(presetKey);
  }

  /// Algoritmo de desconstrucción regresiva progresiva (retroceso de palabras/caracteres)
  List<String> _buildDeconstructionSnapshots(String text) {
    final trimmed = text.trimRight();
    if (trimmed.isEmpty) return [];

    // Para textos cortos (<= 30 caracteres): borrado carácter por carácter hacia atrás
    if (trimmed.length <= 30) {
      final snapshots = <String>[];
      for (int i = trimmed.length - 1; i >= 0; i--) {
        snapshots.add(trimmed.substring(0, i));
      }
      return snapshots;
    }

    // Para textos más extensos: borrado regresivo palabra por palabra / tokens
    final tokens = RegExp(r'\S+\s*').allMatches(trimmed).map((m) => m.group(0)!).toList();
    if (tokens.length <= 4) {
      // 2 a 4 palabras: borrado en pequeños bloques de 2 caracteres para granularidad visible
      final snapshots = <String>[];
      const cluster = 2;
      for (int i = trimmed.length - cluster; i > 0; i -= cluster) {
        snapshots.add(trimmed.substring(0, i));
      }
      snapshots.add('');
      return snapshots;
    }

    // Agrupación y paso regulado para mantener la animación entre 10 y 24 pasos (~450-650ms total)
    final totalTokens = tokens.length;
    const maxSteps = 24;
    final stride = (totalTokens / maxSteps).ceil().clamp(1, totalTokens);

    final snapshots = <String>[];
    int currentTokenCount = totalTokens;

    while (currentTokenCount > 0) {
      currentTokenCount = math.max(0, currentTokenCount - stride);
      if (currentTokenCount == 0) {
        snapshots.add('');
      } else {
        final remaining = tokens.take(currentTokenCount).join('').trimRight();
        snapshots.add(remaining);
      }
    }

    if (snapshots.isEmpty || snapshots.last.isNotEmpty) {
      snapshots.add('');
    }
    return snapshots;
  }

  void _onClearText() async {
    if (_isClearing || _textController.text.trim().isEmpty) return;

    setState(() {
      _isClearing = true;
      _showEmptyHint = false;
    });

    final snapshots = _buildDeconstructionSnapshots(_textController.text);
    final totalSteps = snapshots.length;

    if (totalSteps > 0) {
      // Curva de aceleración algorítmica:
      // Comienza pausado y deliberado (85ms) y adquiere velocidad exponencial (hasta 8ms)
      const double maxDelay = 85.0; // ms por paso al inicio
      const double minDelay = 8.0;  // ms por paso al final

      for (int i = 0; i < totalSteps; i++) {
        if (!mounted) return;

        final newText = snapshots[i];
        _textController.text = newText;
        _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        );

        // Micro-haptic feedback en puntos clave de la progresión
        if (i == 0 || i == totalSteps - 1 || i % 4 == 0) {
          HapticHelper.selectionClick();
        }

        // Progresión no lineal con aceleración cúbica/exponencial
        final progress = totalSteps == 1 ? 1.0 : i / (totalSteps - 1);
        final delayMs = (minDelay + (maxDelay - minDelay) * math.pow(1.0 - progress, 2.4)).round();

        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }

    if (!mounted) return;

    _textController.clear();
    ref.read(brainDumpProvider.notifier).updateText('');
    HapticHelper.lightTap();

    setState(() {
      _isClearing = false;
      _showEmptyHint = false;
    });
  }

  String get _wordCountText {
    final text = _textController.text.trim();
    if (text.isEmpty) return '';
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    return '$words ${words == 1 ? "palabra" : "palabras"}';
  }

  @override
  Widget build(BuildContext context) {
    final dumpState = ref.watch(brainDumpProvider);
    final isDark = context.isDarkMode;

    if (!_isClearing && dumpState.text != _textController.text && dumpState.text.isNotEmpty) {
      _textController.text = dumpState.text;
      _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Section (Brand, Header, Presets)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Badge, Brand & Theme Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const NeuroBadge.status(
                                label: 'Descompresión Cognitiva',
                                dotColor: AppColors.primaryIndigo,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'NEUROTASK',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? AppColors.brandGlowCyan : AppColors.brandDeepBlue,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const ThemeToggleButton(),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Title & Subtitle
                          Text(
                            '¿Qué ronda por tu cabeza?',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: context.textMain, height: 1.2),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Escribí o dictá libremente. El sistema ordenará el camino lógico.',
                            style: TextStyle(fontSize: 12, color: context.textSecondary),
                          ),
                          const SizedBox(height: 14),

                          // Demo quick presets
                          Row(
                            children: [
                              Text('Ejemplos: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.textMuted)),
                              const SizedBox(width: 6),
                              NeuroBadge.chip(
                                label: '🎓 Entrega DAM',
                                onTap: () => _loadPreset('dam'),
                              ),
                              const SizedBox(width: 8),
                              NeuroBadge.chip(
                                label: '📱 Flutter',
                                onTap: () => _loadPreset('flutter'),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Neumorphic Inset Text Area
                      NeuroInsetContainer(
                        height: 220,
                        padding: const EdgeInsets.all(18),
                        borderRadius: 28,
                        border: _showEmptyHint
                            ? Border.all(color: AppColors.amberWarning.withValues(alpha: 0.6), width: 1.5)
                            : null,
                        child: Stack(
                          children: [
                            Semantics(
                              label: 'Campo de texto libre para volcado de ideas',
                              textField: true,
                              child: TextField(
                                controller: _textController,
                                focusNode: _focusNode,
                                maxLines: null,
                                expands: true,
                                style: TextStyle(fontSize: 14, color: context.textMain, height: 1.5),
                                onChanged: (val) {
                                  if (_showEmptyHint && val.trim().isNotEmpty) {
                                    setState(() {
                                      _showEmptyHint = false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Ej: Tengo que testear los endpoints en Postman, redactar el resumen ejecutivo del informe y armar las 7 diapositivas en Figma...',
                                  hintStyle: TextStyle(color: context.textMuted, fontSize: 13),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(bottom: 48, right: 48),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Semantics(
                                button: true,
                                label: 'Dictar por voz',
                                child: InkWell(
                                  onTap: () {
                                    HapticHelper.lightTap();
                                    setState(() {
                                      _showEmptyHint = false;
                                    });
                                    showNeuroModalSheet(
                                      context: context,
                                      builder: (_) => VoiceDictationSheet(
                                        textController: _textController,
                                        onAppendText: (text) {
                                          ref.read(achievementsProvider.notifier).recordVoiceDictation();
                                          setState(() {});
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: context.cardSurface,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: context.subtleElevation,
                                      border: Border.all(color: context.borderLight),
                                    ),
                                    child: const Icon(Icons.mic_rounded, color: AppColors.primaryIndigo, size: 22),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Helper bar: Word count + Smooth Clear Action Button
                      AnimatedOpacity(
                        opacity: _textController.text.trim().isNotEmpty ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _wordCountText,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: context.textMuted,
                                ),
                              ),
                              Semantics(
                                button: true,
                                label: 'Limpiar todo el texto',
                                child: InkWell(
                                  onTap: (_isClearing || _textController.text.trim().isEmpty) ? null : _onClearText,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.clear_all_rounded,
                                          size: 16,
                                          color: isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Limpiar',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Empathetic Validation Hint
                      if (_showEmptyHint)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, color: AppColors.amberDark, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Escribí algunas palabras o elegí un ejemplo arriba 👆 para comenzar.',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.amberDark.withValues(alpha: 0.9)),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Action Button
                      Semantics(
                        button: true,
                        label: 'Descomprimir y Secuenciar camino lógico',
                        child: NeumorphicButton(
                          variant: NeumorphicButtonVariant.primary,
                          borderRadius: 20,
                          height: 56,
                          onPressed: _onProcessAndSequence,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Descomprimir y Secuenciar', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
