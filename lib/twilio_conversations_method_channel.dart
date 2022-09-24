import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'twilio_conversations_platform_interface.dart';

/// An implementation of [TwilioConversationsPlatform] that uses method channels.
class MethodChannelTwilioConversations extends TwilioConversationsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('twilio_conversations');

  @override
  Future<bool?> initClient(String token) async {
    final result = await methodChannel.invokeMethod<bool>('initClient', {'token': token});
    return result;
  }
}
