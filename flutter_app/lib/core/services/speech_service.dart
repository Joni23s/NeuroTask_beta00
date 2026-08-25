import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechState {
  final bool isAvailable;
  final bool isListening;
  final String recognizedWords;
  final double soundLevel;
  final String? errorMessage;

  const SpeechState({
    this.isAvailable = false,
    this.isListening = false,
    this.recognizedWords = '',
    this.soundLevel = 0.0,
    this.errorMessage,
  });

  SpeechState copyWith({
    bool? isAvailable,
    bool? isListening,
    String? recognizedWords,
    double? soundLevel,
    String? errorMessage,
  }) {
    return SpeechState(
      isAvailable: isAvailable ?? this.isAvailable,
      isListening: isListening ?? this.isListening,
      recognizedWords: recognizedWords ?? this.recognizedWords,
      soundLevel: soundLevel ?? this.soundLevel,
      errorMessage: errorMessage,
    );
  }
}

class SpeechNotifier extends StateNotifier<SpeechState> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  SpeechNotifier() : super(const SpeechState()) {
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final available = await _speechToText.initialize(
        onError: _onError,
        onStatus: _onStatus,
      );
      _isInitialized = true;
      state = state.copyWith(isAvailable: available);
    } catch (e) {
      debugPrint('Speech recognition initialization note: $e');
      state = state.copyWith(isAvailable: false);
    }
  }

  void _onError(SpeechRecognitionError error) {
    debugPrint('Speech error: ${error.errorMsg}');
    state = state.copyWith(
      isListening: false,
      errorMessage: error.errorMsg,
    );
  }

  void _onStatus(String status) {
    debugPrint('Speech status: $status');
    if (status == 'notListening' || status == 'done') {
      state = state.copyWith(isListening: false);
    }
  }

  Future<void> startListening({
    required Function(String text) onResult,
    String localeId = 'es_ES',
  }) async {
    if (!_isInitialized) {
      await _initSpeech();
    }

    if (state.isAvailable) {
      state = state.copyWith(isListening: true, recognizedWords: '');
      try {
        await _speechToText.listen(
          onResult: (SpeechRecognitionResult result) {
            final words = result.recognizedWords;
            state = state.copyWith(recognizedWords: words);
            onResult(words);
          },
          onSoundLevelChange: (level) {
            state = state.copyWith(soundLevel: level);
          },
          localeId: localeId,
          listenOptions: SpeechListenOptions(
            cancelOnError: true,
            listenMode: ListenMode.dictation,
          ),
        );
      } catch (e) {
        debugPrint('Speech listen error: $e');
        state = state.copyWith(isListening: false);
      }
    } else {
      // Fallback for environments without speech engine (e.g. desktop simulator)
      state = state.copyWith(isListening: true);
    }
  }

  Future<void> stopListening() async {
    if (state.isAvailable) {
      await _speechToText.stop();
    }
    state = state.copyWith(isListening: false, soundLevel: 0.0);
  }
}

final speechServiceProvider = StateNotifierProvider<SpeechNotifier, SpeechState>((ref) {
  return SpeechNotifier();
});
