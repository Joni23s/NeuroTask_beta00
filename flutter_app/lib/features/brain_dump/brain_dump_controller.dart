import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/providers.dart';

class BrainDumpState {
  final String text;
  final bool isListening;
  final bool isProcessing;

  const BrainDumpState({
    this.text = '',
    this.isListening = false,
    this.isProcessing = false,
  });

  BrainDumpState copyWith({
    String? text,
    bool? isListening,
    bool? isProcessing,
  }) {
    return BrainDumpState(
      text: text ?? this.text,
      isListening: isListening ?? this.isListening,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class BrainDumpNotifier extends Notifier<BrainDumpState> {
  @override
  BrainDumpState build() {
    return const BrainDumpState();
  }

  void updateText(String val) {
    state = state.copyWith(text: val);
  }

  /// Carga presets de volcado mental dinámicamente desde el TaskRepository
  /// eliminando strings hardcodeados dentro del controlador.
  Future<void> loadPreset(String type) async {
    final taskRepo = ref.read(taskRepositoryProvider);
    final presetText = await taskRepo.getPresetText(type);
    if (presetText != null && presetText.isNotEmpty) {
      state = state.copyWith(text: presetText);
    }
  }

  void setListening(bool val) {
    state = state.copyWith(isListening: val);
  }

  void setProcessing(bool val) {
    state = state.copyWith(isProcessing: val);
  }
}

final brainDumpProvider = NotifierProvider<BrainDumpNotifier, BrainDumpState>(
  BrainDumpNotifier.new,
);
