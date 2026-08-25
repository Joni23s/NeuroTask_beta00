import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS('window')
external JSObject get _window;

bool isWebSpeechSupported() {
  try {
    if (_window.hasProperty('NeuroTaskVoice'.toJS).toDart) {
      final voiceObj = _window.getProperty('NeuroTaskVoice'.toJS) as JSObject;
      final res = voiceObj.callMethod('isSupported'.toJS);
      return (res as JSBoolean).toDart;
    }
  } catch (e) {
    // fallback
  }
  return false;
}

void startWebSpeech({
  required Function(String text) onResult,
  required Function(double level) onSoundLevel,
  required Function(String error) onError,
  required Function() onEnd,
}) {
  try {
    if (_window.hasProperty('NeuroTaskVoice'.toJS).toDart) {
      final voiceObj = _window.getProperty('NeuroTaskVoice'.toJS) as JSObject;

      final onResultJs = ((JSString text) {
        onResult(text.toDart);
      }).toJS;

      final onSoundLevelJs = ((JSNumber level) {
        onSoundLevel(level.toDartDouble);
      }).toJS;

      final onErrorJs = ((JSString error) {
        onError(error.toDart);
      }).toJS;

      final onEndJs = (() {
        onEnd();
      }).toJS;

      voiceObj.callMethod(
        'start'.toJS,
        onResultJs,
        onSoundLevelJs,
        onErrorJs,
        onEndJs,
      );
    }
  } catch (e) {
    onError(e.toString());
  }
}

void stopWebSpeech() {
  try {
    if (_window.hasProperty('NeuroTaskVoice'.toJS).toDart) {
      final voiceObj = _window.getProperty('NeuroTaskVoice'.toJS) as JSObject;
      voiceObj.callMethod('stop'.toJS);
    }
  } catch (_) {}
}
