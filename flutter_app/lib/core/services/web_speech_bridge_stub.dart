bool isWebSpeechSupported() => false;

void startWebSpeech({
  required Function(String text) onResult,
  required Function(double level) onSoundLevel,
  required Function(String error) onError,
  required Function() onEnd,
}) {}

void stopWebSpeech() {}
