import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_to_text_state.freezed.dart';

@freezed
class SpeechToTextState with _$SpeechToTextState {
  const factory SpeechToTextState({
    @Default(false) bool isListening,
    @Default(0.0) double soundLevel,
    @Default("") String recognizedWords,
    @Default(false) bool isLoading,
    @Default("Привет, как дела?") String speechActionResult,
    @Default(false) bool isInitialize,
  }) = _SpeechToTextState;

  const SpeechToTextState._();
}
