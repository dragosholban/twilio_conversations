import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'twilio_conversations_platform_interface.dart';

/// An implementation of [TwilioConversationsPlatform] that uses method channels.
class MethodChannelTwilioConversations extends TwilioConversationsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('twilio_conversations');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> initClient() async {
    final result = await methodChannel.invokeMethod<bool>('initClient');
    return result;
  }
}
