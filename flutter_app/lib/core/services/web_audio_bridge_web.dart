import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('window')
external JSObject get _window;

void playWebBrownNoise() {
  try {
    if (_window.hasProperty('NeuroTaskAudio'.toJS).toDart) {
      final audioObj = _window.getProperty('NeuroTaskAudio'.toJS) as JSObject;
      audioObj.callMethod('playBrownNoise'.toJS);
    }
  } catch (_) {}
}

void stopWebBrownNoise() {
  try {
    if (_window.hasProperty('NeuroTaskAudio'.toJS).toDart) {
      final audioObj = _window.getProperty('NeuroTaskAudio'.toJS) as JSObject;
      audioObj.callMethod('stopBrownNoise'.toJS);
    }
  } catch (_) {}
}

void playWebZenChime() {
  try {
    if (_window.hasProperty('NeuroTaskAudio'.toJS).toDart) {
      final audioObj = _window.getProperty('NeuroTaskAudio'.toJS) as JSObject;
      audioObj.callMethod('playZenChime'.toJS);
    }
  } catch (_) {}
}
