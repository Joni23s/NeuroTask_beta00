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
  late AnimationController _pulseController;
  String _currentLiveTranscript = '';
  double _micLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Start real microphone listening as soon as widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListening();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startListening() async {
    final speechNotifier = ref.read(speechServiceProvider.notifier);
    await speechNotifier.startListening(
      onResult: (text) {
        if (mounted) {
          setState(() {
            _currentLiveTranscript = text;
          });
          widget.onAppendText(text);
        }
      },
      onSoundLevel: (level) {
        if (mounted) {
          setState(() {
            _micLevel = level;
          });
        }
      },
    );
  }

  void _toggleListening() async {
    final speechState = ref.read(speechServiceProvider);
    final speechNotifier = ref.read(speechServiceProvider.notifier);

    HapticHelper.lightTap();
    if (speechState.isListening) {
      await speechNotifier.stopListening();
    } else {
      _startListening();
    }
  }

  void _onConfirmAndClose() {
    HapticHelper.success();
    ref.read(speechServiceProvider.notifier).stopListening();
    if (_currentLiveTranscript.trim().isNotEmpty) {
      if (widget.textController.text.trim().isEmpty) {
        widget.textController.text = _currentLiveTranscript.trim();
      } else {
        widget.textController.text = '${widget.textController.text.trim()} ${_currentLiveTranscript.trim()}';
      }
      ref.read(brainDumpProvider.notifier).updateText(widget.textController.text);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final speechState = ref.watch(speechServiceProvider);
    final isListening = speechState.isListening;
    final isAvailable = speechState.isAvailable;
    final isDark = context.isDarkMode;

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

          // Central Microphone Button & Pulsating Ambient Glow
          GestureDetector(
            onTap: _toggleListening,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final pulse = isListening ? (0.85 + (_micLevel * 0.35) + (_pulseController.value * 0.1)) : 1.0;

                return Transform.scale(
                  scale: pulse,
                  child: Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: isListening ? AppColors.primaryIndigo : context.cardSurface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isListening
                              ? AppColors.brandGlowCyan.withValues(alpha: (0.4 + (_micLevel * 0.5)).clamp(0.0, 0.9))
                              : AppColors.indigoGlow.withValues(alpha: 0.15),
                          blurRadius: isListening ? 26 + (_micLevel * 20) : 12,
                          spreadRadius: isListening ? 4 + (_micLevel * 8) : 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        isListening ? Icons.mic_rounded : Icons.mic_off_rounded,
                        color: isListening ? Colors.white : (isDark ? AppColors.brandGlowCyan : AppColors.primaryIndigo),
                        size: 38,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          Text(
            isListening
                ? '🎙️ Escuchando tu voz...'
                : (!isAvailable ? '⚠️ Micrófono no detectado' : '⏸️ Dictado en pausa'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isListening
                ? 'Hablá con tranquilidad. El sistema convertirá tu voz en texto en vivo.'
                : (!isAvailable
                    ? 'Asegurate de otorgar permisos de micrófono en el dispositivo.'
                    : 'Tocá el micrófono para reanudar el dictado.'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: context.textSecondary),
          ),
          const SizedBox(height: 18),

          // Real-time Soundwave Bars reacting to live mic input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(14, (index) {
              // Soundwave height strictly driven by actual microphone sound level
              final waveHeight = isListening
                  ? 8.0 + (_micLevel * 32.0 * (1.0 + math.sin(index * 0.8)).abs())
                  : 6.0;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 70),
                width: 4,
                height: waveHeight.clamp(6.0, 42.0),
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: BoxDecoration(
                  color: isListening
                      ? (_micLevel > 0.15 ? AppColors.brandGlowCyan : AppColors.primaryIndigoLight)
                      : context.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 18),

          // Live Transcription Box (real microphone stream)
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
                    ? (isListening ? 'Esperando tu voz...' : 'Sin texto transcripto aún.')
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
