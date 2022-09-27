import 'package:twilio_conversations/conversation.dart';

import 'twilio_conversations_platform_interface.dart';

class TwilioConversations {
  Future<bool?> initClient(String token) {
    return TwilioConversationsPlatform.instance.initClient(token);
  }

  Future<List<Conversation>> myConversations(String token) async {
    final List<Conversation> conversations = [];
    final data = await TwilioConversationsPlatform.instance.myConversations();
    for (final item in data ?? []) {
      conversations.add(Conversation(
        sid: item['sid'],
        friendlyName: item['friendlyName'],
        lastMessageDate: item['lastMessageDate'],
        lastMessageIndex: item['lastMessageIndex'],
      ));
    }

    return conversations;
  }

  Future<String?> getMessageByIndex(String sid, int index) {
    return TwilioConversationsPlatform.instance.getMessageByIndex(sid, index);
  }

  Future<List<String>> getMessages(String sid) async {
    final List<String> messages = [];
    final data = await TwilioConversationsPlatform.instance.getMessages(sid);
    for (final item in data ?? []) {
      messages.add(item);
    }

    return messages;
  }

  Stream<Map> getTwilioConversationsStream() {
    return TwilioConversationsPlatform.instance.getTwilioConversationsStream();
  }
}
