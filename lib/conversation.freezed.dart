// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  String get sid => throw _privateConstructorUsedError;
  String? get friendlyName => throw _privateConstructorUsedError;
  String? get lastMessageDate => throw _privateConstructorUsedError;
  int? get lastMessageIndex => throw _privateConstructorUsedError;
  int? get lastReadMessageIndex => throw _privateConstructorUsedError;
  String? get attributes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res>;
  $Res call(
      {String sid,
      String? friendlyName,
      String? lastMessageDate,
      int? lastMessageIndex,
      int? lastReadMessageIndex,
      String? attributes});
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res> implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  final Conversation _value;
  // ignore: unused_field
  final $Res Function(Conversation) _then;

  @override
  $Res call({
    Object? sid = freezed,
    Object? friendlyName = freezed,
    Object? lastMessageDate = freezed,
    Object? lastMessageIndex = freezed,
    Object? lastReadMessageIndex = freezed,
    Object? attributes = freezed,
  }) {
    return _then(_value.copyWith(
      sid: sid == freezed
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      friendlyName: friendlyName == freezed
          ? _value.friendlyName
          : friendlyName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageDate: lastMessageDate == freezed
          ? _value.lastMessageDate
          : lastMessageDate // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageIndex: lastMessageIndex == freezed
          ? _value.lastMessageIndex
          : lastMessageIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      lastReadMessageIndex: lastReadMessageIndex == freezed
          ? _value.lastReadMessageIndex
          : lastReadMessageIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_ConversationCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$_ConversationCopyWith(
          _$_Conversation value, $Res Function(_$_Conversation) then) =
      __$$_ConversationCopyWithImpl<$Res>;
  @override
  $Res call(
      {String sid,
      String? friendlyName,
      String? lastMessageDate,
      int? lastMessageIndex,
      int? lastReadMessageIndex,
      String? attributes});
}

/// @nodoc
class __$$_ConversationCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res>
    implements _$$_ConversationCopyWith<$Res> {
  __$$_ConversationCopyWithImpl(
      _$_Conversation _value, $Res Function(_$_Conversation) _then)
      : super(_value, (v) => _then(v as _$_Conversation));

  @override
  _$_Conversation get _value => super._value as _$_Conversation;

  @override
  $Res call({
    Object? sid = freezed,
    Object? friendlyName = freezed,
    Object? lastMessageDate = freezed,
    Object? lastMessageIndex = freezed,
    Object? lastReadMessageIndex = freezed,
    Object? attributes = freezed,
  }) {
    return _then(_$_Conversation(
      sid: sid == freezed
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      friendlyName: friendlyName == freezed
          ? _value.friendlyName
          : friendlyName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageDate: lastMessageDate == freezed
          ? _value.lastMessageDate
          : lastMessageDate // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageIndex: lastMessageIndex == freezed
          ? _value.lastMessageIndex
          : lastMessageIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      lastReadMessageIndex: lastReadMessageIndex == freezed
          ? _value.lastReadMessageIndex
          : lastReadMessageIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Conversation extends _Conversation {
  const _$_Conversation(
      {required this.sid,
      this.friendlyName,
      this.lastMessageDate,
      this.lastMessageIndex,
      this.lastReadMessageIndex,
      this.attributes})
      : super._();

  factory _$_Conversation.fromJson(Map<String, dynamic> json) =>
      _$$_ConversationFromJson(json);

  @override
  final String sid;
  @override
  final String? friendlyName;
  @override
  final String? lastMessageDate;
  @override
  final int? lastMessageIndex;
  @override
  final int? lastReadMessageIndex;
  @override
  final String? attributes;

  @override
  String toString() {
    return 'Conversation(sid: $sid, friendlyName: $friendlyName, lastMessageDate: $lastMessageDate, lastMessageIndex: $lastMessageIndex, lastReadMessageIndex: $lastReadMessageIndex, attributes: $attributes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Conversation &&
            const DeepCollectionEquality().equals(other.sid, sid) &&
            const DeepCollectionEquality()
                .equals(other.friendlyName, friendlyName) &&
            const DeepCollectionEquality()
                .equals(other.lastMessageDate, lastMessageDate) &&
            const DeepCollectionEquality()
                .equals(other.lastMessageIndex, lastMessageIndex) &&
            const DeepCollectionEquality()
                .equals(other.lastReadMessageIndex, lastReadMessageIndex) &&
            const DeepCollectionEquality()
                .equals(other.attributes, attributes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(sid),
      const DeepCollectionEquality().hash(friendlyName),
      const DeepCollectionEquality().hash(lastMessageDate),
      const DeepCollectionEquality().hash(lastMessageIndex),
      const DeepCollectionEquality().hash(lastReadMessageIndex),
      const DeepCollectionEquality().hash(attributes));

  @JsonKey(ignore: true)
  @override
  _$$_ConversationCopyWith<_$_Conversation> get copyWith =>
      __$$_ConversationCopyWithImpl<_$_Conversation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConversationToJson(
      this,
    );
  }
}

abstract class _Conversation extends Conversation {
  const factory _Conversation(
      {required final String sid,
      final String? friendlyName,
      final String? lastMessageDate,
      final int? lastMessageIndex,
      final int? lastReadMessageIndex,
      final String? attributes}) = _$_Conversation;
  const _Conversation._() : super._();

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$_Conversation.fromJson;

  @override
  String get sid;
  @override
  String? get friendlyName;
  @override
  String? get lastMessageDate;
  @override
  int? get lastMessageIndex;
  @override
  int? get lastReadMessageIndex;
  @override
  String? get attributes;
  @override
  @JsonKey(ignore: true)
  _$$_ConversationCopyWith<_$_Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}
