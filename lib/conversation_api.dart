import 'package:twilio_conversations/twilio_conversations_platform_interface.dart';

class ConversationApi {
  Future<List?> getParticipantsList(String sid) async {
    return TwilioConversationsPlatform.instance
        .getConversationParticipantsList(sid);
  }
}
