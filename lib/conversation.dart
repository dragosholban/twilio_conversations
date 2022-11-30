import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twilio_conversations/message.dart';
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
        return Message(
          sid: messageData['messageSid'],
          body: messageData['messageBody'],
          dateCreated: DateTime.parse(messageData['date']),
          participantIdentity: messageData['participantIdentity'],
        );
      }
    }
    return null;
  }

  Future<bool?> getUserIsOnline() {
    return TwilioConversationsPlatform.instance
        .getConversationUserIsOnline(sid);
  }
}
