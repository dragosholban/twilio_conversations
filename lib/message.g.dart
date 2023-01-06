// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      sid: json['sid'] as String,
      body: json['body'] as String?,
      lastMessageDate: json['lastMessageDate'] as String?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      messageIndex: json['messageIndex'] as int?,
      hasMedia: json['hasMedia'] as bool? ?? false,
      medias: (json['medias'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      attributes: json['attributes'] as String?,
      participant: json['participant'] == null
          ? null
          : Participant.fromJson(json['participant'] as Map<String, dynamic>),
      author: json['author'] as String?,
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'body': instance.body,
      'lastMessageDate': instance.lastMessageDate,
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'messageIndex': instance.messageIndex,
      'hasMedia': instance.hasMedia,
      'medias': instance.medias,
      'attributes': instance.attributes,
      'participant': instance.participant,
      'author': instance.author,
    };
