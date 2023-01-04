// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      identity: json['identity'] as String?,
      friendlyName: json['friendlyName'] as String?,
      attributes: json['attributes'] as String?,
      isOnline: json['isOnline'] as bool?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'identity': instance.identity,
      'friendlyName': instance.friendlyName,
      'attributes': instance.attributes,
      'isOnline': instance.isOnline,
    };
