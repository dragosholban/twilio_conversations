// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return _Participant.fromJson(json);
}

/// @nodoc
mixin _$Participant {
  String get sid => throw _privateConstructorUsedError;
  String get conversationSid => throw _privateConstructorUsedError;
  String? get identity => throw _privateConstructorUsedError;
  String? get attributes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParticipantCopyWith<Participant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantCopyWith<$Res> {
  factory $ParticipantCopyWith(
          Participant value, $Res Function(Participant) then) =
      _$ParticipantCopyWithImpl<$Res>;
  $Res call(
      {String sid,
      String conversationSid,
      String? identity,
      String? attributes});
}

/// @nodoc
class _$ParticipantCopyWithImpl<$Res> implements $ParticipantCopyWith<$Res> {
  _$ParticipantCopyWithImpl(this._value, this._then);

  final Participant _value;
  // ignore: unused_field
  final $Res Function(Participant) _then;

  @override
  $Res call({
    Object? sid = freezed,
    Object? conversationSid = freezed,
    Object? identity = freezed,
    Object? attributes = freezed,
  }) {
    return _then(_value.copyWith(
      sid: sid == freezed
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationSid: conversationSid == freezed
          ? _value.conversationSid
          : conversationSid // ignore: cast_nullable_to_non_nullable
              as String,
      identity: identity == freezed
          ? _value.identity
          : identity // ignore: cast_nullable_to_non_nullable
              as String?,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_ParticipantCopyWith<$Res>
    implements $ParticipantCopyWith<$Res> {
  factory _$$_ParticipantCopyWith(
          _$_Participant value, $Res Function(_$_Participant) then) =
      __$$_ParticipantCopyWithImpl<$Res>;
  @override
  $Res call(
      {String sid,
      String conversationSid,
      String? identity,
      String? attributes});
}

/// @nodoc
class __$$_ParticipantCopyWithImpl<$Res> extends _$ParticipantCopyWithImpl<$Res>
    implements _$$_ParticipantCopyWith<$Res> {
  __$$_ParticipantCopyWithImpl(
      _$_Participant _value, $Res Function(_$_Participant) _then)
      : super(_value, (v) => _then(v as _$_Participant));

  @override
  _$_Participant get _value => super._value as _$_Participant;

  @override
  $Res call({
    Object? sid = freezed,
    Object? conversationSid = freezed,
    Object? identity = freezed,
    Object? attributes = freezed,
  }) {
    return _then(_$_Participant(
      sid: sid == freezed
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      conversationSid: conversationSid == freezed
          ? _value.conversationSid
          : conversationSid // ignore: cast_nullable_to_non_nullable
              as String,
      identity: identity == freezed
          ? _value.identity
          : identity // ignore: cast_nullable_to_non_nullable
              as String?,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Participant extends _Participant {
  const _$_Participant(
      {required this.sid,
      required this.conversationSid,
      this.identity,
      this.attributes})
      : super._();

  factory _$_Participant.fromJson(Map<String, dynamic> json) =>
      _$$_ParticipantFromJson(json);

  @override
  final String sid;
  @override
  final String conversationSid;
  @override
  final String? identity;
  @override
  final String? attributes;

  @override
  String toString() {
    return 'Participant(sid: $sid, conversationSid: $conversationSid, identity: $identity, attributes: $attributes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Participant &&
            const DeepCollectionEquality().equals(other.sid, sid) &&
            const DeepCollectionEquality()
                .equals(other.conversationSid, conversationSid) &&
            const DeepCollectionEquality().equals(other.identity, identity) &&
            const DeepCollectionEquality()
                .equals(other.attributes, attributes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(sid),
      const DeepCollectionEquality().hash(conversationSid),
      const DeepCollectionEquality().hash(identity),
      const DeepCollectionEquality().hash(attributes));

  @JsonKey(ignore: true)
  @override
  _$$_ParticipantCopyWith<_$_Participant> get copyWith =>
      __$$_ParticipantCopyWithImpl<_$_Participant>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ParticipantToJson(
      this,
    );
  }
}

abstract class _Participant extends Participant {
  const factory _Participant(
      {required final String sid,
      required final String conversationSid,
      final String? identity,
      final String? attributes}) = _$_Participant;
  const _Participant._() : super._();

  factory _Participant.fromJson(Map<String, dynamic> json) =
      _$_Participant.fromJson;

  @override
  String get sid;
  @override
  String get conversationSid;
  @override
  String? get identity;
  @override
  String? get attributes;
  @override
  @JsonKey(ignore: true)
  _$$_ParticipantCopyWith<_$_Participant> get copyWith =>
      throw _privateConstructorUsedError;
}
