import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/theme_toggle_button.dart';
import '../../focus_viewport/controllers/focus_controller.dart';
import '../../focus_viewport/presentation/single_task_screen.dart';
import '../controllers/brain_dump_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final dumpState = ref.watch(brainDumpProvider);
    final isDark = context.isDarkMode;

    if (dumpState.text != _textController.text && dumpState.text.isNotEmpty) {
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
                              Semantics(
                                label: 'Sección de Descompresión Cognitiva',
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: context.cardSurface,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: context.subtleElevation,
                                    border: Border.all(color: context.borderLight),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(radius: 3.5, backgroundColor: AppColors.primaryIndigo),
                                      SizedBox(width: 6),
                                      Text(
                                        'Descompresión Cognitiva',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryIndigo),
                                      ),
                                    ],
                                  ),
                                ),
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
                              Semantics(
                                button: true,
                                label: 'Cargar ejemplo de Entrega DAM',
                                child: InkWell(
                                  onTap: () => _loadPreset('dam'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: context.cardSurface,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: context.subtleElevation,
                                      border: Border.all(color: context.borderLight),
                                    ),
                                    child: Text('🎓 Entrega DAM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textSecondary)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Semantics(
                                button: true,
                                label: 'Cargar ejemplo de Sprint Flutter',
                                child: InkWell(
                                  onTap: () => _loadPreset('flutter'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: context.cardSurface,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: context.subtleElevation,
                                      border: Border.all(color: context.borderLight),
                                    ),
                                    child: Text('📱 Flutter', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textSecondary)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Neumorphic Inset Text Area
                      Container(
                        height: 220,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: context.pressedSurface,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: context.pressedElevation,
                          border: _showEmptyHint
                              ? Border.all(color: AppColors.amberWarning.withValues(alpha: 0.6), width: 1.5)
                              : Border.all(color: context.borderLight),
                        ),
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
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (_) => VoiceDictationSheet(
                                        textController: _textController,
                                        onAppendText: (text) {
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
