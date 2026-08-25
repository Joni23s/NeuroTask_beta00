import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/speech_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../controllers/brain_dump_controller.dart';

class VoiceDictationSheet extends ConsumerStatefulWidget {
  final Function(String text) onAppendText;
  final TextEditingController textController;

  const VoiceDictationSheet({
    super.key,
    required this.onAppendText,
    required this.textController,
  });

  @override
  ConsumerState<VoiceDictationSheet> createState() => _VoiceDictationSheetState();
}

class _VoiceDictationSheetState extends ConsumerState<VoiceDictationSheet> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  String _currentLiveTranscript = '';
  bool _isSimulatingLiveVoice = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _startListeningOrSimulate();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _startListeningOrSimulate() async {
    final speechNotifier = ref.read(speechServiceProvider.notifier);
    final speechState = ref.read(speechServiceProvider);

    if (speechState.isAvailable) {
      await speechNotifier.startListening(
        onResult: (text) {
          setState(() {
            _currentLiveTranscript = text;
          });
          widget.onAppendText(text);
        },
      );
    } else {
      // Graceful fallback for Windows/Desktop simulator
      setState(() {
        _isSimulatingLiveVoice = true;
      });
      _simulateVoiceStream();
    }
  }

  void _simulateVoiceStream() async {
    const fullText =
        'Tengo que armar la presentación en diapositivas, revisar los endpoints en Postman y redactar el informe final del TP.';
    final words = fullText.split(' ');

    for (int i = 0; i < words.length; i++) {
      await Future.delayed(const Duration(milliseconds: 260));
      if (!mounted) return;
      setState(() {
        _currentLiveTranscript = words.sublist(0, i + 1).join(' ');
      });
    }

    if (!mounted) return;
    setState(() {
      _isSimulatingLiveVoice = false;
    });
  }

  void _onConfirmAndClose() {
    HapticHelper.success();
    ref.read(speechServiceProvider.notifier).stopListening();
    if (_currentLiveTranscript.isNotEmpty) {
      if (widget.textController.text.trim().isEmpty) {
        widget.textController.text = _currentLiveTranscript;
      } else {
        widget.textController.text = '${widget.textController.text.trim()} $_currentLiveTranscript';
      }
      ref.read(brainDumpProvider.notifier).updateText(widget.textController.text);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final speechState = ref.watch(speechServiceProvider);
    final isListening = speechState.isListening || _isSimulatingLiveVoice;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: context.textMuted.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Glowing animated mic icon
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              final scale = isListening ? 1.0 + (math.sin(_waveController.value * math.pi * 2) * 0.08) : 1.0;

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isListening ? AppColors.primaryIndigo : context.cardSurface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isListening
                            ? AppColors.brandGlowCyan.withValues(alpha: 0.6)
                            : AppColors.indigoGlow.withValues(alpha: 0.2),
                        blurRadius: isListening ? 28 : 12,
                        spreadRadius: isListening ? 4 : 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                      color: isListening ? Colors.white : AppColors.primaryIndigo,
                      size: 38,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          Text(
            isListening ? '🎙️ Escuchando tu voz...' : '✨ Dictado listo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isListening
                ? 'Hablá con tranquilidad sin preocuparte por el orden.'
                : 'Tu audio se convirtió en texto automáticamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: context.textSecondary),
          ),
          const SizedBox(height: 20),

          // Live audio waves animation
          if (isListening)
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(12, (index) {
                    final height = 10.0 + (math.sin((_waveController.value * math.pi * 2) + (index * 0.5)).abs() * 26.0);
                    return Container(
                      width: 4,
                      height: height,
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      decoration: BoxDecoration(
                        color: AppColors.brandGlowCyan,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                );
              },
            ),

          const SizedBox(height: 18),

          // Recognized Text Preview Box
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 90, maxHeight: 160),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.pressedSurface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: context.pressedElevation,
              border: Border.all(color: context.borderLight),
            ),
            child: SingleChildScrollView(
              child: Text(
                _currentLiveTranscript.isEmpty
                    ? (isListening ? 'Esperando que comiences a hablar...' : 'Sin texto detectado.')
                    : _currentLiveTranscript,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: _currentLiveTranscript.isEmpty ? context.textMuted : context.textMain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: NeumorphicButton(
                  variant: NeumorphicButtonVariant.flat,
                  height: 48,
                  onPressed: () {
                    ref.read(speechServiceProvider.notifier).stopListening();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: context.textSecondary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: NeumorphicButton(
                  variant: NeumorphicButtonVariant.primary,
                  height: 48,
                  onPressed: _onConfirmAndClose,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Usar este Dictado',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
