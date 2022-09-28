import 'package:freezed_annotation/freezed_annotation.dart';
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
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Future<int?> getUreadMessagesCount() {
    return TwilioConversationsPlatform.instance.getUnreadMessagesCount(sid);
  }
}
