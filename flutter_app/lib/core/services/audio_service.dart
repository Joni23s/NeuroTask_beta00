import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/haptic_helper.dart';
import 'web_audio_bridge.dart';

enum AmbientSoundType {
  none,
  brownNoise,
  rainForest,
}

class AudioState {
  final AmbientSoundType ambientType;
  final bool isMuted;

  const AudioState({
    this.ambientType = AmbientSoundType.none,
    this.isMuted = false,
  });

  bool get isPlayingBrownNoise => ambientType == AmbientSoundType.brownNoise && !isMuted;

  AudioState copyWith({
    AmbientSoundType? ambientType,
    bool? isMuted,
  }) {
    return AudioState(
      ambientType: ambientType ?? this.ambientType,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}

class AudioServiceNotifier extends Notifier<AudioState> {
  @override
  AudioState build() {
    ref.onDispose(() {
      _stopAudio();
    });
    return const AudioState();
  }

  void toggleAmbient(AmbientSoundType type) {
    HapticHelper.lightTap();

    if (state.ambientType == type) {
      // Turn off
      state = state.copyWith(ambientType: AmbientSoundType.none);
      _stopAudio();
    } else {
      // Turn on
      state = state.copyWith(ambientType: type, isMuted: false);
      _playAudio(type);
    }
  }

  void toggleMute() {
    HapticHelper.lightTap();
    final newMute = !state.isMuted;
    state = state.copyWith(isMuted: newMute);

    if (newMute) {
      _stopAudio();
    } else if (state.ambientType != AmbientSoundType.none) {
      _playAudio(state.ambientType);
    }
  }

  void _playAudio(AmbientSoundType type) {
    if (type == AmbientSoundType.brownNoise) {
      if (kIsWeb) {
        playWebBrownNoise();
      }
    }
  }

  void _stopAudio() {
    if (kIsWeb) {
      stopWebBrownNoise();
    }
  }

  void playCompletionChime() {
    if (state.isMuted) return;
    HapticHelper.success();

    if (kIsWeb) {
      playWebZenChime();
    }
  }

}

final audioServiceProvider = NotifierProvider<AudioServiceNotifier, AudioState>(
  AudioServiceNotifier.new,
);
