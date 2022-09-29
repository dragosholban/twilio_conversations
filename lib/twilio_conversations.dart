import 'package:twilio_conversations/conversation.dart';
import 'package:twilio_conversations/message.dart';

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

  Future<Conversation?> getConversation(String sid) async {
    final data =
        await TwilioConversationsPlatform.instance.getConversation(sid);

    final conversation = Conversation(
      sid: data?['sid'],
      friendlyName: data?['friendlyName'],
      lastMessageDate: data?['lastMessageDate'],
      lastMessageIndex: data?['lastMessageIndex'],
    );

    return conversation;
  }

  Future<Message?> getMessageByIndex(String sid, int index) async {
    final data = await TwilioConversationsPlatform.instance
        .getMessageByIndex(sid, index);

    final message = Message(
      sid: data?['messageSid'],
      body: data?['messageBody'],
      dateCreated: DateTime.parse(data?['date']),
      participantIdentity: data?['participantIdentity'],
    );
    return message;
  }

  Future<List<Message>> getMessages(String sid) async {
    final List<Message> messages = [];
    final data = await TwilioConversationsPlatform.instance.getMessages(sid);
    for (final item in data ?? []) {
      final message = Message(
        sid: item['messageSid'],
        body: item['messageBody'],
        dateCreated: DateTime.parse(item['date']),
        participantIdentity: item['participantIdentity'],
      );
      messages.add(message);
    }

    return messages;
  }

  Future sendMessage(String sid, String text) async {
    return await TwilioConversationsPlatform.instance.sendMessage(sid, text);
  }

  Stream<Map> getTwilioConversationsStream() {
    return TwilioConversationsPlatform.instance.getTwilioConversationsStream();
  }
}
