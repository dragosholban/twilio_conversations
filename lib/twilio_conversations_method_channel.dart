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
  Future<List?> myConversations() async {
    final result = await methodChannel.invokeMethod<List>('myConversations');
    return result;
  }

  @override
  Stream<Map> getTwilioConversationsStream() {
    return eventChannel.receiveBroadcastStream().cast();
  }

  @override
  Future<String?> getMessageByIndex(String sid, int index) async {
    final result =
        await methodChannel.invokeMethod<String?>('getMessageByIndex', {
      'sid': sid,
      'index': index,
    });

    return result;
  }

  @override
  Future<List?> getMessages(String sid) async {
    return methodChannel.invokeListMethod('getMessages', {
      'sid': sid,
    });
  }

  @override
  Future sendMessage(String sid, String text) {
    return methodChannel.invokeMethod('sendMessage', {
      'sid': sid,
      'text': text,
    });
  }
}
