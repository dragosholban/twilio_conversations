import 'twilio_conversations_platform_interface.dart';

class TwilioConversations {
  Future<bool?> initClient(String token) {
    return TwilioConversationsPlatform.instance.initClient(token);
  }
}
