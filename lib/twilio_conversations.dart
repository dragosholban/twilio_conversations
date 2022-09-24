import 'twilio_conversations_platform_interface.dart';

class TwilioConversations {
  Future<String?> getPlatformVersion() {
    return TwilioConversationsPlatform.instance.getPlatformVersion();
  }

  Future<bool?> initClient() {
    return TwilioConversationsPlatform.instance.initClient();
  }
}
