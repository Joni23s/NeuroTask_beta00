import 'package:audioplayers/audioplayers.dart';
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
  AudioPlayer? _ambientPlayer;
  AudioPlayer? _sfxPlayer;

  AudioPlayer get _getAmbientPlayer => _ambientPlayer ??= AudioPlayer();
  AudioPlayer get _getSfxPlayer => _sfxPlayer ??= AudioPlayer();

  @override
  AudioState build() {
    ref.onDispose(() {
      _stopAudio();
      _ambientPlayer?.dispose();
      _sfxPlayer?.dispose();
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

  Future<void> _playAudio(AmbientSoundType type) async {
    if (type == AmbientSoundType.brownNoise) {
      if (kIsWeb) {
        playWebBrownNoise();
      } else {
        try {
          final player = _getAmbientPlayer;
          await player.setReleaseMode(ReleaseMode.loop);
          await player.setVolume(0.7);
          await player.play(AssetSource('audio/brown_noise_loop.wav'));
        } catch (e) {
          debugPrint('Error playing native brown noise: $e');
        }
      }
    }
  }

  Future<void> _stopAudio() async {
    if (kIsWeb) {
      stopWebBrownNoise();
    } else {
      try {
        await _ambientPlayer?.stop();
      } catch (e) {
        debugPrint('Error stopping native brown noise: $e');
      }
    }
  }

  Future<void> playCompletionChime() async {
    if (state.isMuted) return;
    HapticHelper.success();

    if (kIsWeb) {
      playWebZenChime();
    } else {
      try {
        final player = _getSfxPlayer;
        await player.setReleaseMode(ReleaseMode.release);
        await player.setVolume(0.85);
        await player.play(AssetSource('audio/zen_chime.wav'));
      } catch (e) {
        debugPrint('Error playing zen chime: $e');
      }
    }
  }
}

final audioServiceProvider = NotifierProvider<AudioServiceNotifier, AudioState>(
  AudioServiceNotifier.new,
);
