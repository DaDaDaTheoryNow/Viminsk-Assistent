// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_to_text_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SpeechToTextState {
  bool get isListening => throw _privateConstructorUsedError;
  double get soundLevel => throw _privateConstructorUsedError;
  String get recognizedWords => throw _privateConstructorUsedError;

  /// Create a copy of SpeechToTextState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeechToTextStateCopyWith<SpeechToTextState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeechToTextStateCopyWith<$Res> {
  factory $SpeechToTextStateCopyWith(
          SpeechToTextState value, $Res Function(SpeechToTextState) then) =
      _$SpeechToTextStateCopyWithImpl<$Res, SpeechToTextState>;
  @useResult
  $Res call({bool isListening, double soundLevel, String recognizedWords});
}

/// @nodoc
class _$SpeechToTextStateCopyWithImpl<$Res, $Val extends SpeechToTextState>
    implements $SpeechToTextStateCopyWith<$Res> {
  _$SpeechToTextStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeechToTextState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isListening = null,
    Object? soundLevel = null,
    Object? recognizedWords = null,
  }) {
    return _then(_value.copyWith(
      isListening: null == isListening
          ? _value.isListening
          : isListening // ignore: cast_nullable_to_non_nullable
              as bool,
      soundLevel: null == soundLevel
          ? _value.soundLevel
          : soundLevel // ignore: cast_nullable_to_non_nullable
              as double,
      recognizedWords: null == recognizedWords
          ? _value.recognizedWords
          : recognizedWords // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpeechToTextStateImplCopyWith<$Res>
    implements $SpeechToTextStateCopyWith<$Res> {
  factory _$$SpeechToTextStateImplCopyWith(_$SpeechToTextStateImpl value,
          $Res Function(_$SpeechToTextStateImpl) then) =
      __$$SpeechToTextStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isListening, double soundLevel, String recognizedWords});
}

/// @nodoc
class __$$SpeechToTextStateImplCopyWithImpl<$Res>
    extends _$SpeechToTextStateCopyWithImpl<$Res, _$SpeechToTextStateImpl>
    implements _$$SpeechToTextStateImplCopyWith<$Res> {
  __$$SpeechToTextStateImplCopyWithImpl(_$SpeechToTextStateImpl _value,
      $Res Function(_$SpeechToTextStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpeechToTextState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isListening = null,
    Object? soundLevel = null,
    Object? recognizedWords = null,
  }) {
    return _then(_$SpeechToTextStateImpl(
      isListening: null == isListening
          ? _value.isListening
          : isListening // ignore: cast_nullable_to_non_nullable
              as bool,
      soundLevel: null == soundLevel
          ? _value.soundLevel
          : soundLevel // ignore: cast_nullable_to_non_nullable
              as double,
      recognizedWords: null == recognizedWords
          ? _value.recognizedWords
          : recognizedWords // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SpeechToTextStateImpl extends _SpeechToTextState {
  const _$SpeechToTextStateImpl(
      {this.isListening = false,
      this.soundLevel = 0.0,
      this.recognizedWords = ""})
      : super._();

  @override
  @JsonKey()
  final bool isListening;
  @override
  @JsonKey()
  final double soundLevel;
  @override
  @JsonKey()
  final String recognizedWords;

  @override
  String toString() {
    return 'SpeechToTextState(isListening: $isListening, soundLevel: $soundLevel, recognizedWords: $recognizedWords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeechToTextStateImpl &&
            (identical(other.isListening, isListening) ||
                other.isListening == isListening) &&
            (identical(other.soundLevel, soundLevel) ||
                other.soundLevel == soundLevel) &&
            (identical(other.recognizedWords, recognizedWords) ||
                other.recognizedWords == recognizedWords));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isListening, soundLevel, recognizedWords);

  /// Create a copy of SpeechToTextState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeechToTextStateImplCopyWith<_$SpeechToTextStateImpl> get copyWith =>
      __$$SpeechToTextStateImplCopyWithImpl<_$SpeechToTextStateImpl>(
          this, _$identity);
}

abstract class _SpeechToTextState extends SpeechToTextState {
  const factory _SpeechToTextState(
      {final bool isListening,
      final double soundLevel,
      final String recognizedWords}) = _$SpeechToTextStateImpl;
  const _SpeechToTextState._() : super._();

  @override
  bool get isListening;
  @override
  double get soundLevel;
  @override
  String get recognizedWords;

  /// Create a copy of SpeechToTextState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeechToTextStateImplCopyWith<_$SpeechToTextStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
