import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'twilio_conversations_platform_interface.dart';

/// An implementation of [TwilioConversationsPlatform] that uses method channels.
class MethodChannelTwilioConversations extends TwilioConversationsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('twilio_conversations');

  @visibleForTesting
  final eventChannel = const EventChannel('twilio_conversations_stream');

  @override
  Future<bool?> initClient(String token) async {
    final result =
        await methodChannel.invokeMethod<bool>('initClient', {'token': token});
    return result;
  }

  @override
  Future<bool?> shutdown() async {
    final result = await methodChannel.invokeMethod<bool>('shutdown');
    return result;
  }

  @override
  Future<List?> myConversations() async {
    final result = await methodChannel.invokeMethod<List>('myConversations');
    return result;
  }

  @override
  Stream<Map> getTwilioConversationsStream() {
    return eventChannel.receiveBroadcastStream().cast();
  }

  @override
  Future<Map?> getConversation(String sid) async {
    final result = await methodChannel.invokeMapMethod('getConversation', {
      'sid': sid,
    });

    return result;
  }

  @override
  Future<Map?> getUser(String identity) async {
    final result = await methodChannel.invokeMapMethod('getUser', {
      'identity': identity,
    });

    return result;
  }

  @override
  Future<Map?> getMessageByIndex(String sid, int index) async {
    final result = await methodChannel.invokeMapMethod('getMessageByIndex', {
      'sid': sid,
      'index': index,
    });

    return result;
  }

  @override
  Future<int?> getMessagesCount(String sid) async {
    return await methodChannel.invokeMethod('getMessagesCount', {
      'sid': sid,
    });
  }

  @override
  Future<int?> getUnreadMessagesCount(String sid) async {
    return await methodChannel.invokeMethod('getUnreadMessagesCount', {
      'sid': sid,
    });
  }

  @override
  Future<int?> setAllMessagesRead(String sid) async {
    return await methodChannel.invokeMethod('setAllMessagesRead', {
      'sid': sid,
    });
  }

  @override
  Future setAttributeForMessage(
    String conversationSid,
    int messageIndex,
    String attributeName,
    dynamic attributeValue,
  ) async {
    return await methodChannel.invokeMethod('setAttributeForMessage', {
      'conversationSid': conversationSid,
      'messageIndex': messageIndex,
      'attributeName': attributeName,
      'attributeValue': attributeValue,
    });
  }

  @override
  Future<List?> getMessages(String sid) async {
    return methodChannel.invokeListMethod('getMessages', {
      'sid': sid,
    });
  }

  @override
  Future<String?> getTemporaryContentUrlForMediaSid(String sid) {
    return methodChannel.invokeMethod('getTemporaryContentUrlForMediaSid', {
      'sid': sid,
    });
  }

  @override
  Future sendMessage({
    required String conversationSid,
    String? body,
    String? path,
    String? mimeType,
    Map<String, dynamic>? attributes,
  }) {
    return methodChannel.invokeMethod('sendMessage', {
      'conversationSid': conversationSid,
      'text': body,
      'path': path,
      'mimeType': mimeType,
      'attributes': attributes,
    });
  }

  @override
  Future<bool?> getConversationUserIsOnline(String sid) {
    return methodChannel.invokeMethod('getConversationUserIsOnline', {
      'sid': sid,
    });
  }

  @override
  Future typing(String sid) {
    return methodChannel.invokeMethod('typing', {
      'sid': sid,
    });
  }

  @override
  Future registerFCMToken(String token) {
    return methodChannel.invokeMethod('registerFCMToken', {
      'token': token,
    });
  }

  @override
  Future registerAPNToken(String token) {
    return methodChannel.invokeMethod('registerAPNToken', {
      'token': token,
    });
  }

  @override
  Future<List?> getConversationParticipantsList(String sid) async {
    return methodChannel.invokeListMethod('conversation.getParticipantsList', {
      'sid': sid,
    });
  }

  @override
  Future<Map?> getConversationParticipantUser(
      String conversationSid, String participantSid) async {
    final result = await methodChannel.invokeMapMethod('participant.getUser', {
      'conversationSid': conversationSid,
      'participantSid': participantSid,
    });

    return result;
  }
}
