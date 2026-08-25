import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/haptic_helper.dart';

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

class AudioServiceNotifier extends StateNotifier<AudioState> {
  AudioServiceNotifier() : super(const AudioState());

  void toggleAmbient(AmbientSoundType type) {
    HapticHelper.lightTap();
    if (state.ambientType == type) {
      state = state.copyWith(ambientType: AmbientSoundType.none);
    } else {
      state = state.copyWith(ambientType: type);
    }
  }

  void toggleMute() {
    HapticHelper.lightTap();
    state = state.copyWith(isMuted: !state.isMuted);
  }

  void playCompletionChime() {
    if (state.isMuted) return;
    HapticHelper.success();
    // System feedback or audio synthesis
  }
}

final audioServiceProvider = StateNotifierProvider<AudioServiceNotifier, AudioState>((ref) {
  return AudioServiceNotifier();
});
