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
  Future sendMessage(String sid, String? body, String? path, String? mimeType) {
    print('Imagepath: $path');
    return methodChannel.invokeMethod('sendMessage', {
      'sid': sid,
      'text': body,
      'path': path,
      'mimeType': mimeType,
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
}
