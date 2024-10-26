import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_to_text_state.freezed.dart';

@freezed
class SpeechToTextState with _$SpeechToTextState {
  const factory SpeechToTextState({
    @Default(false) bool isListening,
    @Default(0.0) double soundLevel,
  }) = _SpeechToTextState;

  const SpeechToTextState._();
}
