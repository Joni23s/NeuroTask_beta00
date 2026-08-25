/**
 * NeuroTask Audio Engine
 * Uses Web Audio API for sensory-friendly, calming sound synthesis.
 * Features:
 * - Tibetan singing bowl / Zen Chime on task completion (positive dopamine)
 * - Brown Noise / Ambient focus noise generator for cognitive calm
 * - Subtle tap/tick audio feedback
 */
class NeuroAudioEngine {
  constructor() {
    this.ctx = null;
    this.isMuted = false;
    this.ambientNode = null;
    this.ambientGain = null;
    this.isAmbientPlaying = false;
  }

  _initContext() {
    if (!this.ctx) {
      const AudioCtx = window.AudioContext || window.webkitAudioContext;
      if (AudioCtx) {
        this.ctx = new AudioCtx();
      }
    }
    if (this.ctx && this.ctx.state === 'suspended') {
      this.ctx.resume();
    }
  }

  toggleMute() {
    this.isMuted = !this.isMuted;
    if (this.isMuted && this.isAmbientPlaying) {
      this.stopAmbientNoise();
    }
    return this.isMuted;
  }

  /**
   * Plays a harmonious, soothing Tibetan singing bowl / meditation chime.
   * Multi-frequency harmonic decay with zero harsh transients.
   */
  playZenCompletionChime() {
    if (this.isMuted) return;
    this._initContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    // Harmonic frequencies (F# chord / 432Hz harmonic series: F#4, A#4, C#5, F#5)
    const frequencies = [369.99, 466.16, 554.37, 739.99];

    frequencies.forEach((freq, index) => {
      const osc = this.ctx.createOscillator();
      const gain = this.ctx.createGain();

      osc.type = 'sine';
      osc.frequency.setValueAtTime(freq, now);

      // Gentle attack to avoid click
      gain.gain.setValueAtTime(0.0001, now);
      const targetGain = 0.08 / (index + 1);
      gain.gain.exponentialRampToValueAtTime(targetGain, now + 0.04 + index * 0.02);
      
      // Long, soothing exponential decay (2.8 seconds)
      gain.gain.exponentialRampToValueAtTime(0.00001, now + 2.8);

      osc.connect(gain);
      gain.connect(this.ctx.destination);

      osc.start(now);
      osc.stop(now + 2.9);
    });

    // Gentle tactile haptic if supported
    if (navigator.vibrate) {
      navigator.vibrate([30, 40, 30]);
    }
  }

  /**
   * Subtle soft click/tap sound for button presses
   */
  playSoftTap() {
    if (this.isMuted) return;
    this._initContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const gain = this.ctx.createGain();

    osc.type = 'sine';
    osc.frequency.setValueAtTime(440, now);
    osc.frequency.exponentialRampToValueAtTime(220, now + 0.05);

    gain.gain.setValueAtTime(0.025, now);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.05);

    osc.connect(gain);
    gain.connect(this.ctx.destination);

    osc.start(now);
    osc.stop(now + 0.06);

    if (navigator.vibrate) {
      navigator.vibrate(10);
    }
  }

  /**
   * Calming Brown Noise Generator (filters high frequencies, recreates soft steady rain/waterfall)
   */
  toggleAmbientNoise() {
    this._initContext();
    if (this.isAmbientPlaying) {
      this.stopAmbientNoise();
      return false;
    } else {
      this.startAmbientNoise();
      return true;
    }
  }

  startAmbientNoise() {
    if (this.isMuted || !this.ctx) return;
    if (this.isAmbientPlaying) return;

    const bufferSize = 2 * this.ctx.sampleRate;
    const noiseBuffer = this.ctx.createBuffer(1, bufferSize, this.ctx.sampleRate);
    const output = noiseBuffer.getChannelData(0);

    let lastOut = 0.0;
    for (let i = 0; i < bufferSize; i++) {
      const white = Math.random() * 2 - 1;
      output[i] = (lastOut + (0.02 * white)) / 1.02;
      lastOut = output[i];
      output[i] *= 3.5; // Gain compensation
    }

    this.ambientNode = this.ctx.createBufferSource();
    this.ambientNode.buffer = noiseBuffer;
    this.ambientNode.loop = true;

    // Lowpass filter to ensure deep warmth
    const filter = this.ctx.createBiquadFilter();
    filter.type = 'lowpass';
    filter.frequency.setValueAtTime(400, this.ctx.currentTime);

    this.ambientGain = this.ctx.createGain();
    this.ambientGain.gain.setValueAtTime(0.001, this.ctx.currentTime);
    this.ambientGain.gain.exponentialRampToValueAtTime(0.035, this.ctx.currentTime + 1.5);

    this.ambientNode.connect(filter);
    filter.connect(this.ambientGain);
    this.ambientGain.connect(this.ctx.destination);

    this.ambientNode.start(0);
    this.isAmbientPlaying = true;
  }

  stopAmbientNoise() {
    if (!this.isAmbientPlaying || !this.ambientGain) return;
    const now = this.ctx ? this.ctx.currentTime : 0;
    try {
      this.ambientGain.gain.exponentialRampToValueAtTime(0.0001, now + 0.8);
      setTimeout(() => {
        if (this.ambientNode) {
          this.ambientNode.stop();
          this.ambientNode.disconnect();
          this.ambientNode = null;
        }
        this.isAmbientPlaying = false;
      }, 850);
    } catch (e) {
      this.isAmbientPlaying = false;
    }
  }
}

window.neuroAudio = new NeuroAudioEngine();
