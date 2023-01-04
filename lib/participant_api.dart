import 'package:twilio_conversations/twilio_conversations_platform_interface.dart';

class ParticipantApi {
  Future<Map?> getUser({
    required String conversationSid,
    required String participantSid,
  }) async {
    return TwilioConversationsPlatform.instance
        .getConversationParticipantUser(conversationSid, participantSid);
  }
}
