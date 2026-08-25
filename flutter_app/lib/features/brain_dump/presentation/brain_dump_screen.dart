import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/neumorphic_theme.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../focus_viewport/controllers/focus_controller.dart';
import '../../focus_viewport/presentation/single_task_screen.dart';
import '../controllers/brain_dump_controller.dart';

class BrainDumpScreen extends ConsumerStatefulWidget {
  const BrainDumpScreen({super.key});

  @override
  ConsumerState<BrainDumpScreen> createState() => _BrainDumpScreenState();
}

class _BrainDumpScreenState extends ConsumerState<BrainDumpScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onProcessAndSequence() async {
    final rawText = _textController.text;
    ref.read(brainDumpProvider.notifier).setProcessing(true);

    // Show peaceful breathing processing modal or transition
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primaryIndigo),
                SizedBox(height: 24),
                Text(
                  'Construyendo Grafo Lógico...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain),
                ),
                SizedBox(height: 8),
                Text(
                  'Eliminando ruido cognitivo y aislando tu primer paso...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    ref.read(focusProvider.notifier).loadFromRawText(rawText);
    ref.read(brainDumpProvider.notifier).setProcessing(false);

    Navigator.pop(context); // Close dialog
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SingleTaskScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dumpState = ref.watch(brainDumpProvider);

    if (dumpState.text != _textController.text && dumpState.text.isNotEmpty) {
      _textController.text = dumpState.text;
      _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Badge & Brand
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: NeumorphicTheme.subtleElevation,
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
                  const Text(
                    'NEUROTASK',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryIndigo, letterSpacing: 1.2),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                '¿Qué ronda por tu cabeza?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain, height: 1.2),
              ),
              const SizedBox(height: 6),
              const Text(
                'Escribí o dictá libremente. El sistema ordenará el camino lógico.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Demo quick presets
              Row(
                children: [
                  const Text('Ejemplos: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => ref.read(brainDumpProvider.notifier).loadPreset('dam'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: NeumorphicTheme.subtleElevation,
                      ),
                      child: const Text('🎓 Entrega DAM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => ref.read(brainDumpProvider.notifier).loadPreset('flutter'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: NeumorphicTheme.subtleElevation,
                      ),
                      child: const Text('📱 Flutter', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Neumorphic Inset Text Area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.pressedSurface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: NeumorphicTheme.pressedElevation,
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        controller: _textController,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(fontSize: 14, color: AppColors.textMain, height: 1.5),
                        decoration: const InputDecoration(
                          hintText: 'Ej: Tengo que testear los endpoints en Postman, escribir el resumen ejecutivo y armar las diapositivas de la entrega...',
                          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          border: InputBorder.none,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () => ref.read(brainDumpProvider.notifier).toggleVoiceSimulation(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.cardSurface,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: NeumorphicTheme.subtleElevation,
                            ),
                            child: const Icon(Icons.mic_none_rounded, color: AppColors.primaryIndigo, size: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action Button
              NeumorphicButton(
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
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
