import 'package:twilio_conversations/conversation.dart';
import 'package:twilio_conversations/message.dart';

import 'twilio_conversations_platform_interface.dart';

export 'constants.dart';
export 'conversation.dart';
export 'message.dart';

class TwilioConversations {
  Future<bool?> initClient(String token) {
    return TwilioConversationsPlatform.instance.initClient(token);
  }

  Future<bool?> shutdown() {
    return TwilioConversationsPlatform.instance.shutdown();
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
      lastReadMessageIndex: data?['lastReadMessageIndex'],
      attributes: data?['attributes'],
    );

    return conversation;
  }

  Future<Message?> getMessageByIndex(String sid, int index) async {
    final data = await TwilioConversationsPlatform.instance
        .getMessageByIndex(sid, index);

    if (data != null) {
      return Message.fromMap(data);
    }

    return null;
  }

  Future<List<Message>> getMessages(String sid) async {
    final List<Message> messages = [];
    final data = await TwilioConversationsPlatform.instance.getMessages(sid);
    for (final item in data ?? []) {
      final message = Message.fromMap(item);
      messages.add(message);
    }

    return messages;
  }

  Future sendMessage({
    required String conversationSid,
    String? body,
    String? path,
    String? mimeType,
    Map<String, dynamic>? attributes,
  }) async {
    return await TwilioConversationsPlatform.instance.sendMessage(
      conversationSid: conversationSid,
      body: body,
      path: path,
      mimeType: mimeType,
      attributes: attributes,
    );
  }

  Stream<Map> getTwilioConversationsStream() {
    return TwilioConversationsPlatform.instance.getTwilioConversationsStream();
  }

  Future typing(String sid) async {
    return await TwilioConversationsPlatform.instance.typing(sid);
  }

  Future registerFCMToken(String token) async {
    return await TwilioConversationsPlatform.instance.registerFCMToken(token);
  }

  Future registerAPNToken(String token) async {
    return await TwilioConversationsPlatform.instance.registerAPNToken(token);
  }
}
