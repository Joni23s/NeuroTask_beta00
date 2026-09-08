import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'web_speech_bridge.dart';

class SpeechState {
  final bool isInitialized;
  final bool isAvailable;
  final bool isListening;
  final String recognizedWords;
  final double soundLevel;
  final String? errorMessage;
  final String? currentLocale;

  const SpeechState({
    this.isInitialized = false,
    this.isAvailable = false,
    this.isListening = false,
    this.recognizedWords = '',
    this.soundLevel = 0.0,
    this.errorMessage,
    this.currentLocale,
  });

  SpeechState copyWith({
    bool? isInitialized,
    bool? isAvailable,
    bool? isListening,
    String? recognizedWords,
    double? soundLevel,
    String? errorMessage,
    String? currentLocale,
  }) {
    return SpeechState(
      isInitialized: isInitialized ?? this.isInitialized,
      isAvailable: isAvailable ?? this.isAvailable,
      isListening: isListening ?? this.isListening,
      recognizedWords: recognizedWords ?? this.recognizedWords,
      soundLevel: soundLevel ?? this.soundLevel,
      errorMessage: errorMessage,
      currentLocale: currentLocale ?? this.currentLocale,
    );
  }
}

class SpeechNotifier extends Notifier<SpeechState> {
  final SpeechToText _speechToText = SpeechToText();

  @override
  SpeechState build() {
    Future.microtask(() => initSpeech());
    return const SpeechState();
  }

  Future<bool> initSpeech() async {
    if (kIsWeb) {
      final webOk = isWebSpeechSupported();
      state = state.copyWith(
        isInitialized: true,
        isAvailable: webOk,
        currentLocale: 'es-ES',
        errorMessage: webOk ? null : 'Web Speech API no disponible en este navegador.',
      );
      return webOk;
    }

    try {
      final available = await _speechToText.initialize(
        onError: _onError,
        onStatus: _onStatus,
        debugLogging: kDebugMode,
      );

      String? selectedLocale;
      if (available) {
        try {
          final locales = await _speechToText.locales();
          final esLocale = locales.where((l) => l.localeId.startsWith('es')).firstOrNull;
          selectedLocale = esLocale?.localeId ?? (locales.isNotEmpty ? locales.first.localeId : null);
        } catch (_) {}
      }

      state = state.copyWith(
        isInitialized: true,
        isAvailable: available,
        currentLocale: selectedLocale,
        errorMessage: available ? null : 'Reconocimiento de voz no soportado en este dispositivo.',
      );
      return available;
    } catch (e) {
      debugPrint('Speech initialization error: $e');
      state = state.copyWith(
        isInitialized: true,
        isAvailable: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void _onError(SpeechRecognitionError error) {
    debugPrint('Speech recognition error: ${error.errorMsg}');
    state = state.copyWith(
      isListening: false,
      soundLevel: 0.0,
      errorMessage: error.errorMsg,
    );
  }

  void _onStatus(String status) {
    debugPrint('Speech status event: $status');
    if (status == 'notListening' || status == 'done') {
      state = state.copyWith(isListening: false, soundLevel: 0.0);
    } else if (status == 'listening') {
      state = state.copyWith(isListening: true);
    }
  }

  Future<void> startListening({
    required Function(String text) onResult,
    Function(double level)? onSoundLevel,
  }) async {
    if (!state.isInitialized || !state.isAvailable) {
      final ok = await initSpeech();
      if (!ok) return;
    }

    state = state.copyWith(isListening: true, recognizedWords: '', errorMessage: null);

    if (kIsWeb) {
      startWebSpeech(
        onResult: (text) {
          state = state.copyWith(recognizedWords: text);
          onResult(text);
        },
        onSoundLevel: (level) {
          state = state.copyWith(soundLevel: level);
          onSoundLevel?.call(level);
        },
        onError: (err) {
          debugPrint('Web Speech error: $err');
          state = state.copyWith(isListening: false, soundLevel: 0.0, errorMessage: err);
        },
        onEnd: () {
          state = state.copyWith(isListening: false, soundLevel: 0.0);
        },
      );
      return;
    }

    try {
      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          final words = result.recognizedWords;
          state = state.copyWith(recognizedWords: words);
          onResult(words);
        },
        onSoundLevelChange: (level) {
          final normalized = ((level + 2.0) / 12.0).clamp(0.0, 1.0);
          state = state.copyWith(soundLevel: normalized);
          onSoundLevel?.call(normalized);
        },
        listenOptions: SpeechListenOptions(
          cancelOnError: false,
          partialResults: true,
          listenMode: ListenMode.dictation,
          localeId: state.currentLocale,
        ),
      );
    } catch (e) {
      debugPrint('Error while listening: $e');
      state = state.copyWith(isListening: false, soundLevel: 0.0, errorMessage: e.toString());
    }
  }

  Future<void> stopListening() async {
    if (kIsWeb) {
      stopWebSpeech();
    } else if (_speechToText.isListening) {
      await _speechToText.stop();
    }
    state = state.copyWith(isListening: false, soundLevel: 0.0);
  }
}

final speechServiceProvider = NotifierProvider<SpeechNotifier, SpeechState>(
  SpeechNotifier.new,
);
