// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get sid => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  String? get lastMessageDate => throw _privateConstructorUsedError;
  DateTime? get dateCreated => throw _privateConstructorUsedError;
  int? get messageIndex => throw _privateConstructorUsedError;
  bool get hasMedia => throw _privateConstructorUsedError;
  List<Map<String, String>> get medias => throw _privateConstructorUsedError;
  String? get attributes => throw _privateConstructorUsedError;
  Participant? get participant => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res>;
  $Res call(
      {String sid,
      String? body,
      String? lastMessageDate,
      DateTime? dateCreated,
      int? messageIndex,
      bool hasMedia,
      List<Map<String, String>> medias,
      String? attributes,
      Participant? participant,
      String? author});

  $ParticipantCopyWith<$Res>? get participant;
}

/// @nodoc
class _$MessageCopyWithImpl<$Res> implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  final Message _value;
  // ignore: unused_field
  final $Res Function(Message) _then;

  @override
  $Res call({
    Object? sid = freezed,
    Object? body = freezed,
    Object? lastMessageDate = freezed,
    Object? dateCreated = freezed,
    Object? messageIndex = freezed,
    Object? hasMedia = freezed,
    Object? medias = freezed,
    Object? attributes = freezed,
    Object? participant = freezed,
    Object? author = freezed,
  }) {
    return _then(_value.copyWith(
      sid: sid == freezed
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageDate: lastMessageDate == freezed
          ? _value.lastMessageDate
          : lastMessageDate // ignore: cast_nullable_to_non_nullable
              as String?,
      dateCreated: dateCreated == freezed
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      messageIndex: messageIndex == freezed
          ? _value.messageIndex
          : messageIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      hasMedia: hasMedia == freezed
          ? _value.hasMedia
          : hasMedia // ignore: cast_nullable_to_non_nullable
              as bool,
      medias: medias == freezed
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as String?,
      participant: participant == freezed
          ? _value.participant
          : participant // ignore: cast_nullable_to_non_nullable
              as Participant?,
      author: author == freezed
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  @override
  $ParticipantCopyWith<$Res>? get participant {
    if (_value.participant == null) {
      return null;
    }

    return $ParticipantCopyWith<$Res>(_value.participant!, (value) {
      return _then(_value.copyWith(participant: value));
    });
  }
}

/// @nodoc
abstract class _$$_MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$_MessageCopyWith(
          _$_Message value, $Res Function(_$_Message) then) =
      __$$_MessageCopyWithImpl<$Res>;
  @override
  $Res call(
      {String sid,
      String? body,
      String? lastMessageDate,
      DateTime? dateCreated,
      int? messageIndex,
      bool hasMedia,
      List<Map<String, String>> medias,
      String? attributes,
      Participant? participant,
      String? author});

  @override
  $ParticipantCopyWith<$Res>? get participant;
}

/// @nodoc
class __$$_MessageCopyWithImpl<$Res> extends _$MessageCopyWithImpl<$Res>
    implements _$$_MessageCopyWith<$Res> {
  __$$_MessageCopyWithImpl(_$_Message _value, $Res Function(_$_Message) _then)
      : super(_value, (v) => _then(v as _$_Message));

  @override
  _$_Message get _value => super._value as _$_Message;

  @override
  $Res call({
    Object? sid = freezed,
    Object? body = freezed,
    Object? lastMessageDate = freezed,
    Object? dateCreated = freezed,
    Object? messageIndex = freezed,
    Object? hasMedia = freezed,
    Object? medias = freezed,
    Object? attributes = freezed,
    Object? participant = freezed,
    Object? author = freezed,
  }) {
    return _then(_$_Message(
      sid: sid == freezed
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageDate: lastMessageDate == freezed
          ? _value.lastMessageDate
          : lastMessageDate // ignore: cast_nullable_to_non_nullable
              as String?,
      dateCreated: dateCreated == freezed
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      messageIndex: messageIndex == freezed
          ? _value.messageIndex
          : messageIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      hasMedia: hasMedia == freezed
          ? _value.hasMedia
          : hasMedia // ignore: cast_nullable_to_non_nullable
              as bool,
      medias: medias == freezed
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<Map<String, String>>,
      attributes: attributes == freezed
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as String?,
      participant: participant == freezed
          ? _value.participant
          : participant // ignore: cast_nullable_to_non_nullable
              as Participant?,
      author: author == freezed
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Message extends _Message {
  const _$_Message(
      {required this.sid,
      this.body,
      this.lastMessageDate,
      this.dateCreated,
      this.messageIndex,
      this.hasMedia = false,
      final List<Map<String, String>> medias = const [],
      this.attributes,
      this.participant,
      this.author})
      : _medias = medias,
        super._();

  factory _$_Message.fromJson(Map<String, dynamic> json) =>
      _$$_MessageFromJson(json);

  @override
  final String sid;
  @override
  final String? body;
  @override
  final String? lastMessageDate;
  @override
  final DateTime? dateCreated;
  @override
  final int? messageIndex;
  @override
  @JsonKey()
  final bool hasMedia;
  final List<Map<String, String>> _medias;
  @override
  @JsonKey()
  List<Map<String, String>> get medias {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medias);
  }

  @override
  final String? attributes;
  @override
  final Participant? participant;
  @override
  final String? author;

  @override
  String toString() {
    return 'Message(sid: $sid, body: $body, lastMessageDate: $lastMessageDate, dateCreated: $dateCreated, messageIndex: $messageIndex, hasMedia: $hasMedia, medias: $medias, attributes: $attributes, participant: $participant, author: $author)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Message &&
            const DeepCollectionEquality().equals(other.sid, sid) &&
            const DeepCollectionEquality().equals(other.body, body) &&
            const DeepCollectionEquality()
                .equals(other.lastMessageDate, lastMessageDate) &&
            const DeepCollectionEquality()
                .equals(other.dateCreated, dateCreated) &&
            const DeepCollectionEquality()
                .equals(other.messageIndex, messageIndex) &&
            const DeepCollectionEquality().equals(other.hasMedia, hasMedia) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality()
                .equals(other.attributes, attributes) &&
            const DeepCollectionEquality()
                .equals(other.participant, participant) &&
            const DeepCollectionEquality().equals(other.author, author));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(sid),
      const DeepCollectionEquality().hash(body),
      const DeepCollectionEquality().hash(lastMessageDate),
      const DeepCollectionEquality().hash(dateCreated),
      const DeepCollectionEquality().hash(messageIndex),
      const DeepCollectionEquality().hash(hasMedia),
      const DeepCollectionEquality().hash(_medias),
      const DeepCollectionEquality().hash(attributes),
      const DeepCollectionEquality().hash(participant),
      const DeepCollectionEquality().hash(author));

  @JsonKey(ignore: true)
  @override
  _$$_MessageCopyWith<_$_Message> get copyWith =>
      __$$_MessageCopyWithImpl<_$_Message>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MessageToJson(
      this,
    );
  }
}

abstract class _Message extends Message {
  const factory _Message(
      {required final String sid,
      final String? body,
      final String? lastMessageDate,
      final DateTime? dateCreated,
      final int? messageIndex,
      final bool hasMedia,
      final List<Map<String, String>> medias,
      final String? attributes,
      final Participant? participant,
      final String? author}) = _$_Message;
  const _Message._() : super._();

  factory _Message.fromJson(Map<String, dynamic> json) = _$_Message.fromJson;

  @override
  String get sid;
  @override
  String? get body;
  @override
  String? get lastMessageDate;
  @override
  DateTime? get dateCreated;
  @override
  int? get messageIndex;
  @override
  bool get hasMedia;
  @override
  List<Map<String, String>> get medias;
  @override
  String? get attributes;
  @override
  Participant? get participant;
  @override
  String? get author;
  @override
  @JsonKey(ignore: true)
  _$$_MessageCopyWith<_$_Message> get copyWith =>
      throw _privateConstructorUsedError;
}
