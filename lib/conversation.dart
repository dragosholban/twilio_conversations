import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twilio_conversations/participant.dart';
import 'package:twilio_conversations/twilio_conversations.dart';
import 'package:twilio_conversations/twilio_conversations_platform_interface.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const Conversation._();

  const factory Conversation({
    required String sid,
    String? friendlyName,
    String? lastMessageDate,
    int? lastMessageIndex,
    int? lastReadMessageIndex,
    String? attributes,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Future<List<Participant>> getParticipantsList() async {
    final result =
        await TwilioConversations().conversationApi.getParticipantsList(sid);

    if (result != null) {
      final participants = List.from(result)
          .map((e) => Participant.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return participants;
    }

    return [];
  }

  Future<int?> getMessagesCount() {
    return TwilioConversationsPlatform.instance.getMessagesCount(sid);
  }

  Future<int?> getUreadMessagesCount() {
    return TwilioConversationsPlatform.instance.getUnreadMessagesCount(sid);
  }

  Future<int?> setAllMessagesRead() {
    return TwilioConversationsPlatform.instance.setAllMessagesRead(sid);
  }

  Future<Message?> getLastMessage() async {
    if (lastMessageIndex != null) {
      final messageData = await TwilioConversationsPlatform.instance
          .getMessageByIndex(sid, lastMessageIndex!);

      if (messageData != null) {
        return Message.fromMap(messageData);
      }
    }
    return null;
  }

  Future<bool?> getUserIsOnline() {
    return TwilioConversationsPlatform.instance
        .getConversationUserIsOnline(sid);
  }
}
