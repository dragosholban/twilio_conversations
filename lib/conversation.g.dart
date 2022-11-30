// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Conversation _$$_ConversationFromJson(Map<String, dynamic> json) =>
    _$_Conversation(
      sid: json['sid'] as String,
      friendlyName: json['friendlyName'] as String?,
      lastMessageDate: json['lastMessageDate'] as String?,
      lastMessageIndex: json['lastMessageIndex'] as int?,
      lastReadMessageIndex: json['lastReadMessageIndex'] as int?,
      attributes: json['attributes'] as String?,
    );

Map<String, dynamic> _$$_ConversationToJson(_$_Conversation instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'friendlyName': instance.friendlyName,
      'lastMessageDate': instance.lastMessageDate,
      'lastMessageIndex': instance.lastMessageIndex,
      'lastReadMessageIndex': instance.lastReadMessageIndex,
      'attributes': instance.attributes,
    };
