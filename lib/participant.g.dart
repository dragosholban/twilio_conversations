// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Participant _$$_ParticipantFromJson(Map<String, dynamic> json) =>
    _$_Participant(
      sid: json['sid'] as String,
      conversationSid: json['conversationSid'] as String,
      identity: json['identity'] as String?,
      attributes: json['attributes'] as String?,
    );

Map<String, dynamic> _$$_ParticipantToJson(_$_Participant instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'conversationSid': instance.conversationSid,
      'identity': instance.identity,
      'attributes': instance.attributes,
    };
