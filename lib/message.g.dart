// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      sid: json['sid'] as String,
      body: json['body'] as String?,
      lastMessageDate: json['lastMessageDate'] as String?,
      participantIdentity: json['participantIdentity'] as String?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'body': instance.body,
      'lastMessageDate': instance.lastMessageDate,
      'participantIdentity': instance.participantIdentity,
      'dateCreated': instance.dateCreated?.toIso8601String(),
    };
