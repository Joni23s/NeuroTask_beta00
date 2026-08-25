import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class BrainDumpNotifier extends StateNotifier<BrainDumpState> {
  BrainDumpNotifier() : super(const BrainDumpState());

  void updateText(String val) {
    state = state.copyWith(text: val);
  }

  void loadPreset(String type) {
    if (type == 'dam') {
      state = state.copyWith(
        text: 'Testear los endpoints del backend en Postman, redactar el resumen ejecutivo de 2 párrafos para el informe y armar las 7 diapositivas visuales en Figma para la entrega de ITU.',
      );
    } else if (type == 'flutter') {
      state = state.copyWith(
        text: 'Definir los tokens de color Soft Paper en Dart, armar la NeumorphicCard reutilizable y programar la pantalla de foco 1 a 1 con Riverpod.',
      );
    }
  }

  void setListening(bool val) {
    state = state.copyWith(isListening: val);
  }

  void setProcessing(bool val) {
    state = state.copyWith(isProcessing: val);
  }
}

final brainDumpProvider = StateNotifierProvider<BrainDumpNotifier, BrainDumpState>((ref) {
  return BrainDumpNotifier();
});
